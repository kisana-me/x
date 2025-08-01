class SignupController < ApplicationController
  before_action :require_signout

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    @account.name_id = SecureRandom.base36(14) if @account.name_id.blank?
    if session[:pending_oauth_info]
      @account.assign_attributes(
        anyur_id: session[:pending_oauth_info].dig("anyur_id"),
        anyur_access_token: session[:pending_oauth_info].dig("anyur_access_token") || "",
        anyur_refresh_token: session[:pending_oauth_info].dig("anyur_refresh_token") || "",
        anyur_token_fetched_at: session[:pending_oauth_info].dig("token_fetched_at") || Time.current
      )
      @account.meta["subscription"] = session[:pending_oauth_info].dig("subscription")
    end
    if @account.save
      sign_in(@account)
      session.delete(:pending_oauth_info)
      redirect_to root_path, notice: "登録完了"
    else
      render :new
    end
  end

  private

  def account_params
    params.expect(account: [ :name, :name_id, :description ])
  end
end
