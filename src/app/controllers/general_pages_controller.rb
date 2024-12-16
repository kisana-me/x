class GeneralPagesController < ApplicationController
  def index
    if @current_account
    else
      @account = Account.new
    end
  end
end
