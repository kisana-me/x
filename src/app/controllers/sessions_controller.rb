class SessionsController < ApplicationController
  before_action :require_signin, except: %i[ signin post_signin ]
  before_action :require_signout, only: %i[ signin post_signin ]
  before_action :set_session, only: %i[ show edit update destroy ]

  def signin
    @account = Account.new
  end

  def post_signin
    @account = Account.new(name_id: params[:signin][:name_id], password: params[:signin][:password])
    account = Account.find_by(name_id: params[:signin][:name_id])
    if account && account.authenticate(password: params[:signin][:password])
      sign_in(account)
      redirect_back_or posts_path, notice: "口座進入完了"
    else
      @account.errors.add(:base, "IDまたはPasswordが違います")
      render :signin, status: :unprocessable_entity, alert: "口座進入不可"
    end
  end

  def signout
    if sign_out
      redirect_to root_path, notice: "口座退出完了"
    else
      redirect_to root_path, alert: "口座退出不可"
    end
  end

  # 以下サインイン済み #

  def index
    @sessions = Session.where(account: @current_account, deleted: false)
  end

  def show
  end

  def edit
  end

  def update
    if @session.update!(session_params)
      redirect_to session_path(@session.token_lookup), notice: "セッションを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @session.update(deleted: true)
    redirect_to sessions_path, notice: "セッションを削除しました"
  end

  private

  def set_session
    @session = Session.find_by(account: @current_account, lookup: params[:id], deleted: false)
  end

  def session_params
    params.require(:session).permit(:name)
  end
end
