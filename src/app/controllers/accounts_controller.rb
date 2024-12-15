class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show ]
  before_action :set_correct_account, only: %i[ edit update ]
  before_action :login_only, only: %i[ edit update destroy ]
  before_action :logout_only, only: %i[ new create login ]

  def index
    @accounts = Account.where(deleted: false)
  end

  def show
    @account_posts = Post
      .where(account: @account, deleted: false)
      .includes(:account, :replied, :replies, :reactions)
      .where(accounts: { deleted: false })
      .order(created_at: :desc)
      .limit(10)
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      do_login(@account)
      redirect_to account_path(@account.name_id), notice: "口座作成完了"
    else
      flash.now[:info] = "口座作成不可"
      render :new, status: :unprocessable_entity
    end
  end

  def login
    @account = Account.new
    if params[:login_password] && account = Account.find_by(login_password: params[:login_password], deleted: false)
      do_login(account)
      redirect_to account_path(account.name_id), notice: "口座進入完了"
    else
      @login_error = "不可"
      flash.now[:info] = "口座進入不可"
      render :new, status: :unprocessable_entity
    end
  end

  def logout
    do_logout()
    redirect_to root_path, notice: "口座退出完了"
  end

  def update
    if @current_account.update(account_params)
      redirect_to account_path(@account.name_id), notice: "口座更新完了"
    else
      flash.now[:info] = "口座更新不可"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @current_account.update(deleted: true)
      redirect_to root_path, notice: "口座削除完了", status: :see_other
    else
      redirect_to root_path, notice: "口座削除不可", status: :see_other
    end
  end

  private
    def set_account
      @account = Account.find_by(name_id: params[:name_id], deleted: false)
    end

    def account_params
      params.expect(account: [ :name, :bio ])
    end

    def set_correct_account
      unless !@current_account || params[:name_id] == @current_account.name_id
        redirect_to account_path(params[:name_id]), notice: "不可操作"
      end
      @account = @current_account
    end
end
