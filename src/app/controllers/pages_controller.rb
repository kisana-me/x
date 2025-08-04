class PagesController < ApplicationController
  def index
    if @current_account
    else
      @account = Account.new
    end
  end

  def terms_of_service
  end

  def privacy_policy
  end

  def contact
  end

  def export
    data = {}
    data["account_post"] = JSON.parse(Account.includes(:posts).to_json(include: :posts))
    data["reaction"] = JSON.parse(Reaction.includes(:account, :post).to_json(include: {
        account: { only: :name_id },
        post: { only: :name_id }
      }))
    render json: data
  end
end
