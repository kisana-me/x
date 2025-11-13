class AccountsController < ApplicationController
  def index
    @accounts = Account
      .is_normal
      .is_opened
      .order(created_at: :desc).limit(20)
  end

  def show
    @account = Account
      .is_normal
      .is_opened
      .find_by(name_id: params[:name_id])
    return render_404 unless @account

    @posts = @account.posts
      .is_normal
      .includes(:account, :replied, :replies, :reactions)
      .order(created_at: :desc)
      .limit(10)
  end
end
