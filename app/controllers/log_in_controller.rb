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
      flash[:notice] = "Username or Password don't match with our database"
      redirect_to log_in_index_path
    end
  end

end
