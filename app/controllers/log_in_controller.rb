class LogInController < ApplicationController

  skip_filter :login

  def index
    if session[:id]
      redirect_to controller: :profiles, id: session[:id]
    end
    @Users = User.all
  end

  def create
#@user = User.where(:username => params[:user][:username], :password => Digest::SHA512.hexdigest(params[:user][:password])).first
    @user = User.authenticate(params[:user][:username], params[:user][:password])
    if @user
      session[:id] = @user.id
      if @user.admin == 1
        redirect_to users_path
      else
        redirect_to "/profiles/#{@user.id}"
      end
    else
      flash[:notice] = "Username or Password don't match with our database"
      redirect_to log_in_index_path
    end
  end

  

end
