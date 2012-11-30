class FrontpageController < ApplicationController

  skip_filter :login

  def index
  	if session[:id]
  		redirect_to "/profiles/#{session[:id]}"
  	end
  end


end
