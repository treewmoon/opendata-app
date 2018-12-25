class UsersController < ApplicationController
  def index
    @title = "Trainer"
  end

  def show
    @user = User.find(params[:id])
    @records = @user.records.order("created_at DESC")
    @title = "My page"
  end
end
