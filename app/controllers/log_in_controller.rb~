class LogInController < ApplicationController

  def index
    @Users = User.all
  end

  def create
    @user = User.where(params[:user]).first
    if @user
      session[:id] = @user.id
      redirect_to profiles_path
    else
      redirect_to users_path
    end
  end

end
