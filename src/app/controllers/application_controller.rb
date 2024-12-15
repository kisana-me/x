class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_current_account

  private
  def set_current_account
    if id = cookies.encrypted[:id]
      @current_account = Account.find_by(login_password: id, deleted: false)
    else
      @current_account = nil
    end
  end

  def do_login(account)
    secure_cookies = ENV["RAILS_SECURE_COOKIES"].present?
    cookies.encrypted[:id] = {
      value: account.login_password,
      domain: :all,
      expires: 1.month.from_now,
      secure: secure_cookies,
      http_only: true
    }
    @current_account = account
  end
  def do_logout
    cookies.delete(:id)
    @current_account = nil
  end
  def login_only
    redirect_to root_path, notice: "口座必須" unless @current_account
  end
  def logout_only
    redirect_to root_path, notice: "既口座有" if @current_account
  end
end
