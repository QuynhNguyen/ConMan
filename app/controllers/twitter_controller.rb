'require twitter'
class TwitterController < ApplicationController

	def index
		@setting = Setting.find_by_user_id(session[:id])
		#access_token = session[:twitter_access_token]
		@client = TwitterOAuth::Client.new(
		    :consumer_key => 'H3fbcU3ByJj1lT81ctvISg',
			:consumer_secret => 'exshVfiVaJv1WDw1LLgMcPTbfeQrONEyRBFxPisMY',
			:token => @setting.twitter_token, 
			:secret => @setting.twitter_secret
		)
		@home_timeline = @client.home_timeline()
		@followers = @client.all_followers()
		@friends = @client.friends()

		#@client.unfriend(15846407)
		#@friend_tl = @client.public_timeline('samsungmobileusa')

		@twitter_contacts = TwitterContact.find_all_by_user_id(session[:id])

		if (@twitter_contacts.count > 0)
			@db_screen_names = []
			@live_screen_names = []
			@twitter_contacts.each do |old|
				@db_screen_names << old.screen_name
			end
			@friends.each do |f|
				@live_screen_names << f["screen_name"]
			end

			@db_screen_names.each_with_index do |old,index|
				unless (@live_screen_names.include? old)
					@twitter_contacts[index].destroy
				end
			end

			@live_screen_names.each_with_index do |neww, index|
				unless (@db_screen_names.include? neww)
					contact = TwitterContact.new(id: @friends[index]["id"].to_i, user_id: session[:id], name: @friends[index]["name"], screen_name: neww, photo: @friends[index]["profile_image_url"])
					contact.save!
				end
			end
			return

		end
		@friends.each do |f|
			contact = TwitterContact.new(id: f["id"].to_i, user_id: session[:id], name: f["name"], screen_name: f["screen_name"], photo: f["profile_image_url"])
			contact.save!
		end


	end

	def tweet
		access_token = session[:twitter_access_token]
		@client = TwitterOAuth::Client.new(
		    :consumer_key => 'H3fbcU3ByJj1lT81ctvISg',
			:consumer_secret => 'exshVfiVaJv1WDw1LLgMcPTbfeQrONEyRBFxPisMY',
			:token => access_token.token,
			:secret => access_token.secret
		)

		@client.update(params[:message])
		flash[:notice] = "Your tweet \"#{params[:message]}\" has been posted!"
		redirect_to action: :index
	end


	def twitter_login
		@client = TwitterOAuth::Client.new(
		    :consumer_key => 'H3fbcU3ByJj1lT81ctvISg',
			:consumer_secret => 'exshVfiVaJv1WDw1LLgMcPTbfeQrONEyRBFxPisMY'
		)
		oauth_confirm_url = "http://localhost:3000/twitter/twitter_authorize"
		request_token = @client.authentication_request_token(:oauth_callback => oauth_confirm_url)
		session[:request_token] = request_token
		redirect_to request_token.authorize_url
	end

	def twitter_authorize
		request_token = session[:request_token]
		@client = TwitterOAuth::Client.new(
		    :consumer_key => 'H3fbcU3ByJj1lT81ctvISg',
			:consumer_secret => 'exshVfiVaJv1WDw1LLgMcPTbfeQrONEyRBFxPisMY',
			:oauth_verifier => params[:oauth_verifier]
		)
		access_token = @client.authorize(
		  request_token.token,
		  request_token.secret,
		  :oauth_verifier => params[:oauth_verifier]
		)
		@setting = Setting.find_by_user_id(session[:id])
		if (@setting)
			@setting.twitter_token = access_token.token
			@setting.twitter_secret = access_token.secret
			@setting.save!
		else
			setting = Setting.new(user_id: session[:id], twitter_token: access_token.token, twitter_secret: access_token.secret)
			setting.save!
		session[:twitter_access_token] = access_token
		end
		redirect_to action: :index
	end

end
