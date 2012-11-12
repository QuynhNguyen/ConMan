'require koala'
'require json'
class FbController < ApplicationController
	#before_filter :login
	def index
		
	end

	def get_permission
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
		@Facebook_cookies ||= @oauth.get_user_info_from_cookies(cookies) 
		@graph = Koala::Facebook::API.new(@Facebook_cookies["access_token"])
		url  = @oauth.url_for_oauth_code(permissions: "read_friendlists,read_mailbox,read_requests,read_stream,ads_management,manage_friendlists,manage_notifications,friends_online_presence,publish_checkins,publish_stream")
		redirect_to url
	end


	def update_status	
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
		@graph = Koala::Facebook::API.new(session[:fb_access_token])
		@graph.put_wall_post(params[:fb_status_message])
		redirect_to action: :index
	end

	def get_friend_list
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
		@graph = Koala::Facebook::API.new(session[:fb_access_token])
		friends = @graph.get_connections("me", "friends")
		id_list = []
		friends.each do |f|
			id_list << f["id"]
		end
		session[:fb_friend_list] = id_list
		redirect_to controller: :profiles, action: :index
	end

	def get_newsfeed
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
		@graph = Koala::Facebook::API.new(session[:fb_access_token])
		feed = @graph.get_connections("me", "feed")
		#flash[:notice] = feed
		#redirect_to action: :index
	end

	def login
		if (!session[:fb_access_token])
			get_permission()
		end
		#respond_to do |format|
		#	format.js
		#end
	end

	def logout
		reset_session
		redirect_to action: :index
	end

	def inbox

	end
end
