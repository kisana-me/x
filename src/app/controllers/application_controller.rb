class ApplicationController < ActionController::Base
  include ErrorsManagement

  before_action :set_current_account

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def set_current_account
    if id = cookies.encrypted[:x]
      @current_account = Account.find_by(login_password: id, deleted: false)
    else
      @current_account = nil
    end
  end

  def do_login(account)
    cookies.encrypted[:x] = {
      value: account.login_password,
      domain: :all,
      tld_length: 3,
      same_site: :lax,
      expires: 1.month.from_now,
      secure: Rails.env.production?,
      http_only: true
    }
    @current_account = account
  end

  def do_logout
    cookies.delete(:x)
    @current_account = nil
  end

  def login_only
    redirect_to root_path, notice: "口座必須" unless @current_account
  end

  def logout_only
    redirect_to root_path, notice: "既口座有" if @current_account
  end

end
