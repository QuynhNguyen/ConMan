class SettingsController < ApplicationController
	def index

	end

	def get_fb_permission
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/profiles')
		@facebook_cookies ||= @oauth.get_user_info_from_cookies(cookies) 
		session[:fb_access_token] = @facebook_cookies["access_token"]
		@graph = Koala::Facebook::API.new(session[:fb_access_token] )
		@url  = @oauth.url_for_oauth_code(permissions: "read_friendlists,read_mailbox,read_requests,read_stream,ads_management,manage_friendlists,manage_notifications,friends_online_presence,publish_checkins,publish_stream")
		#session[:fb_access_token] = @oauth.exchange_access_token(session[:fb_access_token])
		#flash[:notice] =  @oauth.exchange_access_token_info(session[:fb_access_token])
		flash[:notice ] = session[:fb_access_token]
		redirect_to controller: :profiles, action: :index

	end
end
