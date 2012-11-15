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

  def delete
    if @user.admin
      status = Status.find(params[:status_id])
      status.update_attributes(:message => "")
    end
    redirect_to "/profiles/#{params[:user_id]}"
  end

  def get_user
  	@user = User.find(session[:id])
  end
end
