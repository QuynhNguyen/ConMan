class UsernameRecoveryController < ApplicationController

  skip_filter :login
  
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
      api = GoogleVoice::Api.new('project.conman@gmail.com','Raging_Flamingos')
      message = "Project ConMan. PLEASE DON'T REPLY THIS SMS. Your username is " + @user.username
      api.sms(@user.phone.to_s(), message)
      flash[:notice] = "We have sent the username to your phone"
      redirect_to log_in_index_path
    else
      flash[:notice]= "Email is not in our database"
      redirect_to username_recovery_index_path
    end
  end
end
