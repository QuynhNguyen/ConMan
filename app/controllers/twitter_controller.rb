'require twitter'
class TwitterController < ApplicationController
	before_filter :before

	def before
	@client = TwitterOAuth::Client.new(
	    :consumer_key => 'H3fbcU3ByJj1lT81ctvISg',
		:consumer_secret => 'exshVfiVaJv1WDw1LLgMcPTbfeQrONEyRBFxPisMY'
	)

	end


	def index
	end

	def tweet
		request_token = session[:request_token]
		access_token = @client.authorize(
		  request_token.token,
		  request_token.secret,
		  :oauth_verifier => params[:oauth_verifier]
		)
		@client.update(params[:message])


		#@client = Twitter::Client.new(consumer_key: "H3fbcU3ByJj1lT81ctvISg", consumer_secrect: "exshVfiVaJv1WDw1LLgMcPTbfeQrONEyRBFxPisMY", oauth_token: session[:twitter_oauth_token], oauth_token_secret: session[:twitter_oauth_secret])
		#@client = Twitter::Client.new(outh_token: "900537602-pEPUPkjMQ298wriHHuruUzGnWmWImuVteUxoCcU",oauth_token_secret: "F0UiEJC1aBC5w3xxzy7dgg3jwbiIWEhiLMsA9uh0s")
		#@client = Twitter::Client.new(outh_token: session[:twitter_oauth_token],oauth_token_secret: session[:twitter_oauth_secret])

		#@client.update(params[:message])
		#Thread.new{@client.update("Tweeting as Erik!")}
		#Twitter.update(params[:message])
		flash[:notice] = 'Tweet has been posted!'
		notice = []
		notice << "oauth_token"
		notice << params[:oauth_token]
		notice << "request token"
		notice << request_token.token
		notice << "request secret"
		notice << request_token.secret
		notice << "veerifier"
		notice << params[:oauth_verifier]
		flash[:notice] = notice
		redirect_to action: :index
	end


	def twitter2
		oauth_confirm_url = "http://localhost:3000/twitter/index"
		request_token = @client.authentication_request_token(:oauth_callback => oauth_confirm_url)
		session[:request_token] = request_token
		redirect_to request_token.authorize_url

	end
	def login
		auth = request.env["omniauth.auth"]  

        session[:twitter_oauth_token] = params[:oauth_token]
		session[:twitter_oauth_secret] = params[:oauth_verifier]
		notice = []
		notice << "oauth_token"
		notice << params[:oauth_token]
		notice << "secret"
		notice << params[:oauth_verifier]
		flash[:notice] = auth.token
		redirect_to action: :index
	end
end
