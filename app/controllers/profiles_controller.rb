class ProfilesController < ApplicationController
	def index	
		@fb_friend_images = []
		@fb_friends_list = flash[:fb_friends_list]
		if (flash[:fb_friends_images])
			flash[:fb_friends_images].each do |image|
				@fb_friend_images << image
			end

		end
	end 

	def fb_wall()
		@friend = params[:friend_id]
	end

	def post_fb_wall()
		@graph = Koala::Facebook::API.new(session[:fb_access_token] )
		@graph.put_wall_post(params[:message],{name: 'test'},params["friend_id"])
		flash[:notice] = "Your message #{params[:message]} has been posted on #{params[:friend_id]}'s wall"
		flash[:notice] = params[:friend_id]
		redirect_to action: :index
	end
	
	def update_fb_status	
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
		@fb_friends_images = []
		@fb_friends_list = []
		@friends.each do |f|
			@fb_friends_images << @graph.get_picture(f["id"])
			@fb_friends_list << f["id"]
		end
		flash[:fb_friends_images] = @fb_friends_images
		flash[:fb_friends_list] = @fb_friends_list
		redirect_to action: :index
	end

	def fb_logout
		reset_session
		redirect_to action: :index
	end





end
