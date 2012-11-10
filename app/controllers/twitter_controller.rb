class TwitterController < ApplicationController
	def index
		@nothing = 'lala'
	end

	def tweet
		#Thread.new{@client.update(params[:message]}
		@client = Twitter::Client.new(oauth_token: '900537602-pEPUPkjMQ298wriHHuruUzGnWmWImuVteUxoCcU', oauth_token_secret:'F0UiEJC1aBC5w3xxzy7dgg3jwbiIWEhiLMsA9uh0s')
		@client.update(params[:message])
		flash[:notice] = 'Tweet has been posted!'
		redirect_to action: :index
	end

	def login
		oauth_callback = "http:localhost:3000/twitter/index"
		oauth_consumer_key = 'H3fbcU3ByJj1lT81ctvISg'
		oauth_nonce = 'random'
		oauth_siganture = 

	end
end
