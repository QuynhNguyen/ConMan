class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_404
  end

  def render_404
    respond_to do |format|
      format.html { render "errors/404", :status => '404 Not Found', :layout => false }
      format.xml  { render :nothing => true, :status => '404 Not Found' }
    end
  end
end
