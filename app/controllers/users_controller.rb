class UsersController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @user = User.find(id) # look up movie by unique ID
    redirect_to profiles_path
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @users = User.all
  end

  def new
    # default: render 'new' template
  end

 def create
    if params[:user][:password] == params[:user][:repassword]
        @user = User.create!(:admin => params[:user][:admin], :username => params[:user][:username], :first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :address => params[:user][:address], :phone => params[:user][:phone], :email => params[:user][:email], :birthday => params[:user][:birthday], :password => User.encrypt(params[:user][:password]))
    
      flash[:notice] = "#{@user.username} was successfully created."
      redirect_to users_path
    else
      flash[:notice] = "Password and confirm password doesn't match."
      redirect_to new_user_path
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if params[:user][:password] == params[:user][:repassword]
      @user = User.find params[:id]
      if params[:user][:password] == ""
        @user.update_attributes!(:admin => params[:user][:admin], :username => params[:user][:username], :first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :address => params[:user][:address], :phone => params[:user][:phone], :email => params[:user][:email], :birthday => params[:user][:birthday])
      else
        @user.update_attributes!(:admin => params[:user][:admin], :username => params[:user][:username], :first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :address => params[:user][:address], :phone => params[:user][:phone], :email => params[:user][:email], :birthday => params[:user][:birthday], :password => User.encrypt(params[:user][:password]))
      end
      flash[:notice] = "#{@user.username} was successfully updated."
      redirect_to users_path
    else
      flash[:notice] = "Password and confirm password doesn't match."
      redirect_to edit_user_path(params[:id])
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "User '#{@user.username}' deleted."
    redirect_to users_path
  end

end
