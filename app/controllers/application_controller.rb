class ApplicationController < ActionController::Base
	#rescue_from Koala::Facebook::APIError, :with => :handle_fb_exception
  protect_from_forgery
  protected
	  def handle_fb_exception exception
	  if exception.fb_error_type.eql? 'OAuthException'
	    logger.debug "[OAuthException] Either the user's access token has expired, they've logged out of Facebook, deauthorized the app, or changed their password"
			oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/profiles')
	    # If there is a code in the url, attempt to request a new access token with it
	    if params.has_key? 'code'
	      code = params['code']
	      logger.debug "We have the following code in the url: #{code}"
	      logger.debug "Attempting to fetch a new access token..."
	      #token_hash = oauth.get_access_token_info(params[:code])
	      session[:fb_oauth_token]  = @oauth.get_access_token(code)
	      flash[:notice ] = session[:fb_oauth_token]
	      logger.debug "Obtained the following hash for the new access token:"
	      logger.debug session[:fb_oauth_token].to_yaml
	      redirect_to controller: :profiles, action: :index
	    else # Since there is no code in the url, redirect the user to the Facebook auth page for the app
				url = oauth.url_for_oauth_code(permissions: "read_friendlists,read_mailbox,read_requests,read_stream,ads_management,manage_friendlists,manage_notifications,friends_online_presence,publish_checkins,publish_stream")
	      logger.debug "No code was present; redirecting to the following url to obtain one: #{url}"
	      redirect_to url
	    end
	  else
	    logger.debug "Since the error type is not an 'OAuthException', this is likely a bug in the Koala gem; reraising the exception..."
	    raise exception
	  end
	end
end
