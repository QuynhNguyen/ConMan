class FrontpageController < ApplicationController

  skip_filter :login

  def index

  end

  def log_out
  	reset session
  	redirect_to action: :index
  end

  def show
  	redirect_to action: :index
  end

end
