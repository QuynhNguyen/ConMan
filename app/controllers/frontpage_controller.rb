class FrontpageController < ApplicationController

  skip_filter :login

  def index
    if(session[:id])
      redirect_to controller: :profiles, action: :index, id: session[:id]
    end
  end

  def log_out
    reset_session
  	redirect_to action: :index
  end

  def show
    reset_session
  	redirect_to action: :index
  end

end
