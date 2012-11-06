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
    @user = User.create!(params[:user])
    flash[:notice] = "#{@user.username} was successfully created."
    redirect_to users_path
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    @user.update_attributes!(params[:user])
    flash[:notice] = "#{@user.username} was successfully updated."
    redirect_to users_path
    #username   = params[:users][:username]
    #admin      = params[:users][:admin]
    #first_name = params[:users][:first_name]
    #last_name  = params[:users][:last_name]
    #phone      = params[:users][:phone]
    #address    = params[:users][:address]
    #email      = params[:users][:email]
    #birthday   = params[:users][:birthday]
    #password   = params[:users][:password]
    #repassword = params[:users][:password_confirmation]
    #if password == repassword
      #@user = User.find params[:id]
      #if password == ""
      #  @user.update!(username, first_name, last_name, address, phone, admin, email, birthday)
      #else
        #@user.update_attributes!(:params[:users])
      #end
      #flash[:notice] = "#{@user.username} was successfully updated."
      #redirect_to users_path
    #else
      #flash[:notice] = "Password and confirm password doesn't match."
    #end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "User '#{@user.username}' deleted."
    redirect_to users_path
  end

end
