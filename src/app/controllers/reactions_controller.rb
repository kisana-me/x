class ReactionsController < ApplicationController
  before_action :require_signin

  def react
    @post = Post.find_by(aid: params[:aid])
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
    redirect_to post_path(@post.aid), notice: notice_msg
  end
end
