class LogInController < ApplicationController

  def index
    @Users = User.all
  end

  def create
#@user = User.where(:username => params[:user][:username], :password => Digest::SHA512.hexdigest(params[:user][:password])).first
    @user = User.authenticate(params[:user][:username], params[:user][:password])
    if @user
      session[:id] = @user.id
      session[:user] = @user
      redirect_to "/profiles/#{@user.id}"
    else
      flash[:notice] = "Username or Password don't match with our database"
      redirect_to log_in_index_path
    end
  end

end
