class ProfilesController < ApplicationController
	#GET /profiles
	def index
		#If we leave this as default, Rails will automatically
		#render index.html.erb
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
		@graph = Koala::Facebook::API.new(session[:fb_access_token])		
		@fb_friend_images = []
		if (flash[:fb_friend_list])
			flash[:fb_friend_list].each do |id| 
				@fb_friend_images << @graph.get_picture(id)
			end
		end
	end 


	def get_fb_permission
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
		@Facebook_cookies ||= @oauth.get_user_info_from_cookies(cookies) 
		@graph = Koala::Facebook::API.new(@Facebook_cookies["access_token"])
		url  = @oauth.url_for_oauth_code(permissions: "read_friendlists,read_mailbox,read_requests,read_stream,ads_management,manage_friendlists,manage_notifications,friends_online_presence,publish_checkins,publish_stream")
		redirect_to url
	end


	def update_fb_status	
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
		@graph = Koala::Facebook::API.new(session[:fb_access_token])
		@graph.put_wall_post(params[:fb_status_message])
		redirect_to action: :index
	end

	def get_fb_friend_list
		@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
		@graph = Koala::Facebook::API.new(session[:fb_access_token])
		friends = @graph.get_connections("me", "friends")
		id_list = []
		friends.each do |f|
			id_list << f["id"]
		end
		flash[:fb_friend_list] = id_list
		redirect_to action: :index
	end

end
