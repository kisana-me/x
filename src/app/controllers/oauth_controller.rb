class OauthController < ApplicationController
  require "net/http"
  def start
    state = SecureRandom.base36(24)
    session[:oauth_state] = state
    oauth_authorize_url = "https://anyur.com/oauth/authorize?" + {
      response_type: "code",
      client_id: "x_ekusu",
      redirect_uri: Rails.env.development? ? "http://localhost:3000/callback" : "https://x.amiverse.net/callback",
      scope: "id",
      state: state
    }.to_query

    redirect_to oauth_authorize_url, allow_other_host: true
  end

  def callback
    if params[:state] != session[:oauth_state]
      render plain: "Invalid state parameter", status: :unauthorized
      return
    end
    session.delete(:oauth_state)
    code = params[:code]
    token_response = Net::HTTP.post_form(
      URI("https://anyur.com/oauth/token"),
      {
        grant_type: "authorization_code",
        client_id: "x_ekusu",
        client_secret: ENV["OAUTH_CLIENT_SECRET"],
        redirect_uri: Rails.env.development? ? "http://localhost:3000/callback" : "https://x.amiverse.net/callback",
        code: code
      }
    )
    if token_response.code.to_i != 200
      render plain: "OAuth token request failed: #{token_response.code} #{token_response.body}", status: :unauthorized
      return
    end
    token_data = JSON.parse(token_response.body)
    access_token = token_data["access_token"]
    expires_in = token_data["expires_in"]
    refresh_token = token_data["refresh_token"]
    # データ取得
    info_uri = URI("https://anyur.com/api/resources")
    info_request = Net::HTTP::Post.new(info_uri)
    info_request["Authorization"] = "Bearer #{access_token}"
    info_request["Content-Type"] = "application/json"
    info_response = Net::HTTP.start(info_uri.hostname, info_uri.port, use_ssl: info_uri.scheme == "https") do |http|
      http.request(info_request)
    end
    if info_response.code.to_i != 200
      render plain: "Information request failed: #{info_response.code} #{info_response.body}", status: :unauthorized
      return
    end
    info = JSON.parse(info_response.body)
    # サインイン or サインアップ
    account = Account.find_by(anyur_id: info.dig("data", "id"), deleted: false)
    if @current_account
      if @current_account == account
        redirect_to edit_account_path(@current_account.name_id), alert: "既同口座連携有"
      elsif account
        redirect_to edit_account_path(@current_account.name_id), alert: "既別口座連携有"
      else
        @current_account.update!(anyur_id: info.dig("data", "id"))
        redirect_to edit_account_path(@current_account.name_id), info: "口座連携完了"
      end
    else
      if account
        do_login(account)
        redirect_to posts_path, notice: "口座進入完了"
      else
        account = Account.new(anyur_id: info.dig("data", "id"), name: "連携済新規口座")
        if account.save
          do_login(account)
          redirect_to posts_path, notice: "口座作成・連携完了"
        else
          flash.now[:alert] = "口座作成不可"
          render :new, status: :unprocessable_entity
        end
      end
    end
  end
end
