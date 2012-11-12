class StatusesController < ApplicationController

  before_filter :get_user
  # GET /statuses
  # GET /statuses.json
  def index
  	render "statuses/index"
  end

  def update
  	render "statuses/index"
  end

  def get_user
  	@user = User.find(session[:id])
  end
end
