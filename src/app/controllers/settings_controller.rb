class SettingsController < ApplicationController
  before_action :require_signin
  before_action :set_account, only: %i[ account post_account ]

  def index
  end

  def account
  end

  def post_account
    if @account.update(account_params)
      redirect_to settings_account_path, notice: '更新完了'
    else
      render :account
    end
  end

  def leave
    @current_account.update(deleted: true)
    sign_out
    redirect_to root_url, notice: '口座削除完了'
  end

  private

  def set_account
    @account = Account.isnt_deleted.find_by(id: @current_account.id)
  end

  def account_params
    params.expect(
      account: [
        :name,
        :name_id,
        :description,
        :birthdate,
        :visibility,
        :password,
        :password_confirmation
      ]
    )
  end
end
