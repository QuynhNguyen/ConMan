require 'net/http'
require 'json'
require 'open-uri'
class FbController < ApplicationController

	skip_filter :login
	#GET /profiles
	def index
		@user = User.find(session[:id])
		@setting ||= Setting.find_by_user_id(@user.id)

		if (@setting)
			begin
				@fb_token = @setting.fb_token
				flash[:notice] = 'token exists'
			rescue Exception
				@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
				@fb_cookies ||= @oauth.get_user_info_from_cookies(cookies) 
				@fb_token = @oauth.exchange_access_token(@fb_cookies["access_token"])
				@setting.fb_token = @fb_token
				@setting.save!
				flash[:notice] = 'saving token'
			end
		else
			@oauth = Koala::Facebook::OAuth.new('430537743669484', '8dae7f1d828b5549c029724040921dc8','http://localhost:3000/fb/index')
			@fb_cookies ||= @oauth.get_user_info_from_cookies(cookies) 
			@fb_token = @oauth.exchange_access_token(@fb_cookies["access_token"])
			@setting = Setting.new(user_id: @user.id, fb_token: @fb_token)
			@setting.save!
			flash[:notice] = 'creating token'
		end
		
	
		@graph = Koala::Facebook::API.new(@fb_token)
		@fb_friends_images = []
		@fb_friends_list = []
		@online_friends = @graph.fql_query("SELECT uid, name FROM user WHERE online_presence IN ('active') AND uid IN (SELECT uid2 FROM friend WHERE uid1 = me())")
		@online_friends.each do |f|
			@fb_friends_list << f["uid"]
			@fb_friends_images << @graph.get_picture(f["uid"])
		end
		@fb_status = @graph.fql_query("SELECT message FROM status WHERE uid=me() LIMIT 1")[0]["message"]

		#to = Time.now.to_i
		from = 7.day.ago.to_i
		@friends_request = @graph.fql_query("SELECT uid_from, message FROM friend_request WHERE uid_to = me()")
		@feed = @graph.fql_query("SELECT actor_id, target_id, action_links, message , permalink, type FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me() AND type='newsfeed') AND is_hidden = 0")
	
		@threads = @graph.fql_query("SELECT thread_id, subject, recipients FROM thread WHERE folder_id = 0 LIMIT 5")
		@fb_inbox = []
		@threads.each do |t|
			@fb_inbox << @graph.fql_query("SELECT author_id, body FROM message WHERE thread_id = #{t["thread_id"]} AND created_time > #{from}")
		end


	end



	
	def fb_wall()
		@user = User.find(session[:id])
		@setting ||= Setting.find_by_user_id(@user.id)
		@graph = Koala::Facebook::API.new(@setting.fb_token)	
		@friend_id = params[:friend_id]
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

	def delete_friend
		@user = User.find(session[:id])
		@setting ||= Setting.find_by_user_id(@user.id)
		@graph = Koala::Facebook::API.new(@setting.fb_token)	
		@friend_id = params[:friend_id]
		@me = @graph.get_object("me")["id"]

		uri = URI.parse("https://www.facebook.com/#{@me}/members/#{@friend_id}")
		http = Net::HTTP.new(uri.host, uri.port)
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		http.use_ssl = true
		request = Net::HTTP::Delete.new(uri.path)
		request.set_form_data(access_token: @setting.fb_token)
		@response = http.request(request).code
	end

end
