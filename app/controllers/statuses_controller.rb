class StatusesController < ApplicationController

  before_filter :get_user
  skip_filter :verify_authenticity_token
  # GET /statuses
  # GET /statuses.json
  def index
  	render "statuses/index"
  end

  def update
    begin
      @user.status.update_attributes(:message => params[:message])
    rescue
      self.create
    end

    render "statuses/index"
  end

  def create
    status = Status.create(:message => params[:message])
    @user.status = status
    @user.save!
  end

  def get_user
  	@user = User.find(session[:id])
  end
end
