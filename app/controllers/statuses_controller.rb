class StatusesController < ApplicationController
  # GET /statuses
  # GET /statuses.json
  def index
   
    @user = User.find(session[:id])
    @user.statuses.create(:message => "FK ME")
  end

 
end
