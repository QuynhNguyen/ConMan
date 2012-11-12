class ProfilesController < ApplicationController
	#before_filter :fb_login
	def index	
		#@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/profiles')
		#@facebook_cookies ||= @oauth.get_user_info_from_cookies(cookies) 
		#session[:fb_access_token] = @facebook_cookies["access_token"]
		#@graph = Koala::Facebook::API.new(session[:fb_access_token] )	
		@fb_friend_images = []
		if (flash[:fb_friends_list])
			flash[:fb_friends_list].each do |image|
				@fb_friend_images << image
			end
			#session[:fb_friends_list].each do |id|
			#	@fb_friends_images << @graph.get_picture(id)
			#end
		end

		#@friends = @graph.get_connections("me", "friends")
		#@fb_friends_images = []
		#@friends.each do |f|
		#	@fb_friends_images << @graph.get_picture(f["id"])
		#end
	end 

	def get_fb_permission
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/profiles')
		@facebook_cookies ||= @oauth.get_user_info_from_cookies(cookies) 
		session[:fb_access_token] = @facebook_cookies["access_token"]
		@graph = Koala::Facebook::API.new(session[:fb_access_token] )
		@url  = @oauth.url_for_oauth_code(permissions: "read_friendlists,read_mailbox,read_requests,read_stream,ads_management,manage_friendlists,manage_notifications,friends_online_presence,publish_checkins,publish_stream")
		#session[:fb_access_token] = @oauth.exchange_access_token(session[:fb_access_token])
		flash[:notice] =  @oauth.exchange_access_token_info(session[:fb_access_token])
		redirect_to @url

	end

	def fb_login
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
		#@facebook_cookies = @oauth.get_user_info_from_cookies(session[:fb_access_token]) 
		@graph = Koala::Facebook::API.new(session[:fb_access_token])
		flash[:notice] = session[:fb_access_token]
		#me = @graph.get_connections("me")
		#session[:fb_access_token] = @oauth.exchange_access_token(@facebook_cookies["access_token"])
	end

	def fb_wall()
		@friend = params[:friend_id]
	end

	def post_fb_wall()

		@graph.put_wall_post(params[:message],{name: 'test'},"minhta")
	end
	
	def update_fb_status	
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/profiles')
		@facebook_cookies ||= @oauth.get_user_info_from_cookies(cookies) 
		session[:fb_access_token] = @facebook_cookies["access_token"]
		@graph = Koala::Facebook::API.new(session[:fb_access_token] )
		@graph.put_wall_post(params[:fb_status_message])
		redirect_to action: :index
	end

	def get_fb_friend_list
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/profiles')
		@facebook_cookies ||= @oauth.get_user_info_from_cookies(cookies) 
		session[:fb_access_token] = @facebook_cookies["access_token"]
		@graph = Koala::Facebook::API.new(session[:fb_access_token] )
		@friends = @graph.get_connections("me", "friends")
		@fb_friends_list = []
		@friends.each do |f|
			@fb_friends_list << @graph.get_picture(f["id"])
		end
		flash[:fb_friends_list] = @fb_friends_list
		redirect_to action: :index
	end

	def fb_logout
		reset_session
		redirect_to action: :index
	end
end
