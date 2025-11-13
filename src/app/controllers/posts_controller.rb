class PostsController < ApplicationController
  before_action :set_post, only: %i[ show destroy ]
  before_action :require_signin, except: %i[ index load_more show ]

  def index
    @posts = Post
      .from_normal_account
      .from_opened_account
      .is_normal
      .includes(:account, :replied, :replies, :reactions)
      .order(created_at: :desc)
      .limit(10)
  end

  def load_more
    post = Post
      .from_normal_account
      .from_opened_account
      .is_normal
      .find_by(aid: params[:offset])
    unless post
      render layout: false, turbo_stream: [
        turbo_stream.append("posts", partial: "posts/post", collection: []),
        turbo_stream.update("load-more-button", partial: "posts/end_of_posts")
      ]
      return
    end
    @posts = Post
      .from_normal_account
      .from_opened_account
      .is_normal
      .where("posts.created_at < ?", post.created_at)
      .includes(:account, :replied, :replies, :reactions)
      .order(created_at: :desc)
      .limit(20)
    render layout: false, turbo_stream: [
      turbo_stream.append("posts", partial: "posts/post", collection: @posts),
      if @posts.size == 20
        turbo_stream.update("load-more-button", partial: "posts/load_more_button", locals: { offset: @posts.last.aid })
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
    @post.replied = Post.find_by(aid: params[:post][:replied])
    if @post.save
      redirect_to post_path(@post.aid), notice: "投稿作成完了"
    else
      render :new, status: :unprocessable_entity, notice: "投稿作成不可"
    end
  end

  def destroy
    if @post.account_id == @current_account.id && @post.update(status: :deleted)
      redirect_to posts_path, status: :see_other, notice: "投稿削除完了"
    else
      redirect_to post_path(@post.aid), status: :see_other, notice: "投稿削除不可"
    end
  end

  private

  def set_post
    @post = Post.find_by(aid: params[:aid])
  end

  def post_params
    params.expect(post: [ :content ])
  end
end
