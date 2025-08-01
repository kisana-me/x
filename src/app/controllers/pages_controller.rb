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
end
