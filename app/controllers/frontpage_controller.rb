class FrontpageController < ApplicationController

  skip_filter :login

  def index
    if(session[:id])
      redirect_to controller: :profiles, action: :index, id: session[:id]
    end
  end


end
