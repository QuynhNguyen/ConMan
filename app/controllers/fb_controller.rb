require 'net/http'
require 'json'
require 'open-uri'
class FbController < ApplicationController
	#skip_filter :login
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
				flash[:notice] = 'update token'
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
		@fb_friends_request_names =[]
		@fb_friends_request_images =[]
		@fb_inbox = []
		@actors = []
		@authors = []

		@online_friends, @fb_status, @friends_request, @feed, @threads = @graph.batch do |batch_api|
			batch_api.fql_query("SELECT uid, name FROM user WHERE online_presence IN ('active') AND uid IN (SELECT uid2 FROM friend WHERE uid1 = me())")
			batch_api.fql_query("SELECT message FROM status WHERE uid=me() LIMIT 1")
			batch_api.fql_query("SELECT uid_from, message FROM friend_request WHERE uid_to = me()")			
			batch_api.fql_query("SELECT actor_id, target_id, action_links, message , permalink, type FROM stream WHERE filter_key in (SELECT filter_key FROM stream_filter WHERE uid=me() AND type='newsfeed') AND is_hidden = 0")
			batch_api.fql_query("SELECT thread_id, subject, recipients FROM thread WHERE folder_id = 0 LIMIT 5")
		end

		@fb_friends_images = @graph.batch do |batch_api|
			@online_friends.each do |f|
				@fb_friends_list << f["uid"]
				batch_api.get_picture(f["uid"])
			end
		end
		@fb_friends_request_names = @graph.batch do |batch_api|
			@friends_request.each do |f|
				batch_api.get_object(f["uid_from"])
			end
		end
		@fb_friends_request_images = @graph.batch do |batch_api|
			@friends_request.each do |f|
				batch_api.get_picture(f["uid_from"])
			end
		end
		@actors = @graph.batch do |batch_api|
			@feed.each do |f|
				batch_api.get_object(f["actor_id"])
			end
		end
		#to = Time.now.to_i
		from = 7.day.ago.to_i
		@fb_inbox = @graph.batch do |batch_api|
			@threads.each do |t|
				batch_api.fql_query("SELECT author_id, body FROM message WHERE thread_id = #{t["thread_id"]} AND created_time > #{from}")
			end
		end
		@authors = @graph.batch do |batch_api|
			@fb_inbox.each do |m|
				m.each do |message|
					batch_api.get_object(message["author_id"])
				end
			end
		end
				

	end

	def friends
		@user = User.find(session[:id])
		@setting ||= Setting.find_by_user_id(@user.id)
		@graph = Koala::Facebook::API.new(@setting.fb_token)	
		@contacts = FbContact.find_all_by_user_id(@user.id)
		if (@contacts.count >0)
			flash[:notice] = "you have friends"
			return
		end

		@friends = @graph.get_connections("me","friends")
		@images =[]
		@friends.each_slice(50) do |friends|
			@images << @graph.batch do |batch_api|
				friends.each do |f|
					batch_api.get_picture(f["id"])
				end
			end
		end
		@fb_friends_images = []
		@images.each do |list|
			list.each do |image|
				@fb_friends_images << image
			end
		end

		@friends.each_with_index do |f,index|
			friend = FbContact.new(user_id: @user.id, friend_id: f["id"],name: f["name"], photo: @fb_friends_images[index])
			friend.save!
		end

	end
	
	def fb_wall
		@user = User.find(session[:id])
		@setting ||= Setting.find_by_user_id(@user.id)
		@graph = Koala::Facebook::API.new(@setting.fb_token)	
		@friend_id = params[:friend_id]
	end

	def post_fb_wall
		@user = User.find(session[:id])
		@setting ||= Setting.find_by_user_id(@user.id)
		@graph = Koala::Facebook::API.new(@setting.fb_token)
		@graph.put_wall_post(params[:message],{name: 'test'},params["friend_id"])
		flash[:notice] = "Your message #{params[:message]} has been posted on #{params[:friend_id]}'s wall"
		redirect_to action: :fb_wall, friend_id: params["friend_id"]
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

		#uri = URI.parse("https://www.facebook.com/#{@me}/members")
		uri = URI.parse("https://graph.facebook.com")
		http = Net::HTTP.new(uri.host, uri.port)
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		http.use_ssl = true
		#request = Net::HTTP::Delete.new(uri.path)
		request = Net::HTTP::Post.new(uri.request_uri)
		#request.set_form_data(members: "#{@friend_id}", access_token: @setting.fb_token)

		para = { method: :delete,
			relative_url: "#{@me}/members/#{@friend_id}"
		}
		params={	access_token: @setting.fb_token,
			batch: "["+para.to_json+ "]"
		}
		request.body = params.to_query
		@response = http.request(request).body
		flash[:notice] = "Sending and accepting friend requests is not available via the Facebook Graph API for regular user accounts."
	end


end
