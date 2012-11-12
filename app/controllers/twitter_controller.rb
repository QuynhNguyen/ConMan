'require twitter'
class TwitterController < ApplicationController
	def index
		@nothing = 'lala'
	end

	def tweet
		#Thread.new{@client.update(params[:message]}
		#@client = Twitter::Client.new(oauth_token: session[:twitter_oauth_token], oauth_token_secret: session[:twitter_oauth_verifier])
		@client = Twitter::Client.new(oauth_token: '900537602-pEPUPkjMQ298wriHHuruUzGnWmWImuVteUxoCcU',oauth_token_secret: 'F0UiEJC1aBC5w3xxzy7dgg3jwbiIWEhiLMsA9uh0s')
		#@client.update(params[:message])
		flash[:notice] = 'Tweet has been posted!'
		Twitter.update(params[:message])
		redirect_to action: :index
	end

	def login
		session[:twitter_oauth_token] = params[:oauth_token]
		session[:twitter_oauth_verifier] = params[:oauth_verifier]
		notice = []
		notice << "oauth_token"
		notice << params[:oauth_token]
		notice << "verifier"
		notice << params[:oauth_verifier]
		flash[:notice] = notice
		redirect_to action: :index
	end
end
