class UsersController < ApplicationController
  skip_filter :login
  def show
    if (session[:id] != nil )
      id = params[:id] # retrieve movie ID from URI route
      @user = User.find(id) # look up movie by unique ID
      redirect_to "/profiles/#{session[:id]}"
    else
      flash[:notice] = "You need to log in first"
      redirect_to log_in_index_path
    end
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if (session[:id] != nil)
      if (User.find(session[:id]).admin == 1)
        @users = User.all
      else
        flash[:notice] = "You are not an admin"
        redirect_to "/profiles/#{session[:id]}"
      end
    else
      flash[:notice] = "You need to log in first"
      redirect_to log_in_index_path
    end
  end

  def new
    # default: render 'new' template
  end

 def create
    if params[:user][:password] == params[:user][:repassword]
        @user = User.create!(:admin => params[:user][:admin], :username => params[:user][:username], :first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :address => params[:user][:address], :phone => params[:user][:phone], :email => params[:user][:email], :password => User.encrypt(params[:user][:password]))
    
      flash[:notice] = "#{@user.username} was successfully created."
      if (session[:id] == nil)
        redirect_to log_in_index_path
      elsif(User.find(session[:id]).admin == 1)
        redirect_to users_path
      end
    else
      flash[:notice] = "Password and confirm password doesn't match."
      redirect_to new_user_path
    end
  end

  def edit
    if (session[:id] != nil)
      if (User.find(session[:id]).admin == 1)
        @user = User.find params[:id]
      else
        @user = User.find session[:id]
      end
    else
      flash[:notice] = "You need to log in first"
      redirect_to log_in_index_path
    end
  end

  def update
    if (session[:id] != nil)
      @user = User.find params[:id]
      if params[:user][:password] == params[:user][:repassword]
        if params[:user][:password] == ""
          @user.update_attributes!(:admin => params[:user][:admin], :username => params[:user][:username], :first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :address => params[:user][:address], :phone => params[:user][:phone], :email => params[:user][:email])
        else
          @user.update_attributes!(:admin => params[:user][:admin], :username => params[:user][:username], :first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :address => params[:user][:address], :phone => params[:user][:phone], :email => params[:user][:email], :password => User.encrypt(params[:user][:password]))
        end
        flash[:notice] = "#{@user.username} was successfully updated."
        redirect_to users_path
      else
        flash[:notice] = "Password and confirm password doesn't match."
        redirect_to edit_user_path(params[:id])
      end
    else
        flash[:notice] = "You need to log in first"
        redirect_to log_in_index_path
    end
  end

  def destroy
    if (session[:id] != nil)
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "User '#{@user.username}' deleted."
      redirect_to users_path
    else
      flash[:notice] = "You need to log in first"
      redirect_to log_in_index_path
    end
  end
end
