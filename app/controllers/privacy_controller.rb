class PrivacyController < ApplicationController

  def show
    id = session[:id] # retrieve movie ID from URI route
    @user = User.find(id) # look up movie by unique ID
    redirect_to "/profiles/#{session[:id]}"
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
  end

  def edit
    @user = User.find session[:id]
  end

  def update
    @user = User.find session[:id]
    @user.update_attributes!(:show_fn => params[:user][:show_fn], :show_ln => params[:user][:show_ln], :show_addr => params[:user][:show_addr], :show_phone => params[:user][:show_phone], :show_email => params[:user][:show_email])
    flash[:notice] = "#{@user.username} was successfully updated."
    redirect_to "/profiles/#{session[:id]}"
  end

  def destroy
  end
end
