class AccountsController < ApplicationController

  def index
    @accounts = Account.all
  end

  def show
    @account = Account.find_by(name_id: params[:name_id])
    @posts = Post
      .where(account: @account, deleted: false)
      .includes(:account, :replied, :replies, :reactions)
      .order(created_at: :desc)
      .limit(10)
  end

  private

  def account_params
    params.expect(account: [ :name, :name_id, :description ])
  end
end
