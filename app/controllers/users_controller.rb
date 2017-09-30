class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.admin == true
      @users = User.all
    else
      @users = User.where("admin = 'true'")
    end
  end

  def show
      @user = User.find(params[:id])
  end

end
