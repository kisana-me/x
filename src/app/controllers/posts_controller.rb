class PostsController < ApplicationController
  before_action :set_post, only: %i[ show destroy ]
  before_action :login_only, except: :index

  def index
    @posts = Post
      .where(deleted: false)
      .includes(:account, :replied, :replies, :reactions)
      .where(accounts: { deleted: false })
      .order(created_at: :desc)
      .limit(10)
  end

  def load_more
    post = Post.find_by(name_id: params[:offset], deleted: false)
    post = nil if post&.account&.deleted
    unless post
      render layout: false, turbo_stream: [
        turbo_stream.append("posts", partial: "posts/post", collection: []),
        turbo_stream.update("load-more-button", partial: "posts/end_of_posts")
      ]
      return
    end
    @posts = Post
      .where("posts.created_at < ?", post.created_at)
      .where(deleted: false)
      .joins(:account)
      .where(accounts: { deleted: false })
      .includes(:account, :replied, :replies, :reactions)
      .order(created_at: :desc)
      .limit(20)
    render layout: false, turbo_stream: [
      turbo_stream.append("posts", partial: "posts/post", collection: @posts),
      if @posts.size == 20
        turbo_stream.update("load-more-button", partial: "posts/load_more_button", locals: { offset: @posts.last.name_id })
      else
        turbo_stream.update("load-more-button", partial: "posts/end_of_posts")
      end
    ].compact
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.account = @current_account
    replied = params[:post][:replied]
    @post.replied = if replied
      Post
        .where(name_id: replied, deleted: false)
        .includes(:account)
        .where(accounts: { deleted: false })
        .first
    end
    if @post.save
      redirect_to post_path(@post.name_id), notice: "投稿作成完了"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # def edit
  # end

  # def update
  #   if @post.update(post_params)
  #     redirect_to @post, notice: "投稿更新完了"
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  def destroy
    if @post.account == @current_account && @post.update(deleted: true)
      redirect_to posts_path, status: :see_other, notice: "投稿削除完了"
    else
      redirect_to post_path(@post.name_id), status: :see_other, notice: "投稿削除不可"
    end
  end

  private
    def set_post
      @post = Post
        .where(name_id: params[:name_id], deleted: false)
        .includes(:account, :replied, :replies, :reactions)
        .where(accounts: { deleted: false })
        .first
    end

    def post_params
      params.expect(post: [ :content ])
    end
end
