'require twitter'
class TwitterController < ApplicationController

	def index
		access_token = session[:access_token]
		@client = TwitterOAuth::Client.new(
		    :consumer_key => 'H3fbcU3ByJj1lT81ctvISg',
			:consumer_secret => 'exshVfiVaJv1WDw1LLgMcPTbfeQrONEyRBFxPisMY',
			:token => access_token.token,
			:secret => access_token.secret
		)
		@home_timeline = @client.home_timeline()
		@followers = @client.all_followers()
		@friends = @client.friends()
	end

	def tweet
		access_token = session[:access_token]
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
		session[:access_token] = access_token
		redirect_to action: :index
	end

end
