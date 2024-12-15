class ReactionsController < ApplicationController
  before_action :set_post, only: %i[ react ]
  before_action :login_only

  def react
    existing_reaction = @post.reactions.find_by(account: @current_account)
    if existing_reaction
      if existing_reaction.kind == params[:kind]
        existing_reaction.destroy
        notice_msg = "評価削除完了"
      else
        existing_reaction.update(kind: params[:kind])
        notice_msg = "評価変更完了"
      end
    else
      @reaction = Reaction.new(
        kind: params[:kind],
        account: @current_account,
        post: @post
      )
      if @reaction.save
        notice_msg = "評価作成完了"
      else
        notice_msg = "評価作成不可" + @reaction.errors.full_messages.to_sentence
      end
    end
    redirect_to post_path(@post.name_id), notice: notice_msg
  end

  private

  def set_post
    @post = Post
      .where(name_id: params[:name_id], deleted: false)
      .includes(:account, :replied, :replies)
      .where(accounts: { deleted: false })
      .first
  end
end
