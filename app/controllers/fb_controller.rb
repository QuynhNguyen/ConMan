require 'net/http'
require 'json'
require 'open-uri'
class FbController < ApplicationController

	skip_filter :login
	#GET /profiles
	def index
		@user = User.find(session[:id])
		@setting ||= Setting.find_by_id(@user.id)
		if (@setting)
			@fb_token = @setting.fb_token
		else
			@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
			@fb_cookies ||= @oauth.get_user_info_from_cookies(cookies) 
			@fb_token = @oauth.exchange_access_token(@fb_cookies["access_token"])
			@setting = Setting.new(user_id: @user.id, fb_token: @fb_token)
			@setting.save!
		end
		@graph = Koala::Facebook::API.new(@fb_token)
		@friends = @graph.get_connections("me", "friends")
		@fb_friends_images = []
		@fb_friends_list = []
		index = 0
		@friends.each do |f|
			break if index == 10
			@fb_friends_list << f["id"]
			@fb_friends_images << @graph.get_picture(f["id"])
			index+=1
		end
		to = Time.now.to_i
		from = 1.day.ago.to_i
		@f_requests = @graph.fql_query("SELECT uid_from, time, message FROM friend_request WHERE uid_to = me()")
		@feed = @graph.fql_query("SELECT actor_id, target_id, message FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me() AND type='newsfeed') AND is_hidden = 0
")
		 # require 'open-uri'
		#  file = open("https://graph.facebook.com/19292868552")
		 # file.read
	end



	
	def fb_wall()
		@friend = params[:friend_id]
	end

	def post_fb_wall()
		@user = User.find(session[:id])
		@setting ||= Setting.find_by_id(@user.id)
		@graph = Koala::Facebook::API.new(@setting.fb_token)
		@graph.put_wall_post(params[:message],{name: 'test'},params["friend_id"])
		flash[:notice] = "Your message #{params[:message]} has been posted on #{params[:friend_id]}'s wall"
		flash[:notice] = params[:friend_id]
		redirect_to action: :index
	end
	
	def update_fb_status	
		@user = User.find(session[:id])
		@setting ||= Setting.find_by_id(@user.id)
		@graph = Koala::Facebook::API.new(@setting.fb_token)
		@graph.put_wall_post(params[:fb_status_message])
		redirect_to action: :index
	end


end
