class UsernameRecoveryController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @user = User.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @Users = User.all
  end

  def create
    @user = User.where(params[:user]).first
    if @user
      session[:id] = @user.id
      redirect_to username_recovery_path(@user)
    else
      redirect_to username_recovery_index_path
    end
  end
end
