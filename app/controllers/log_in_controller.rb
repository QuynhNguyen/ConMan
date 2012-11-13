class LogInController < ApplicationController

  skip_filter :login

  def index
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
>>>>>>> b9950502cc02b61520ecc4e17a9a487a06c985a3
    else
      flash[:notice] = "Username or Password don't match with our database"
      redirect_to log_in_index_path
    end
  end

end
