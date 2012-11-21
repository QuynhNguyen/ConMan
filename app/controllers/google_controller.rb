require 'gmail'
require 'net/http'
require 'net/https'
require 'uri'
require "json"
require 'google/api_client'

class GoogleController < ApplicationController
	CLIENT_ID = '178522046203.apps.googleusercontent.com'
	CLIENT_SECRET = 'jiTeMBbzOwNPrHfFaLirfIp1'
	REDIRECT_URI = 'http://localhost:3000/google/index'

  def g_login
  	#gmail = Gmail.connect('project.conman','Raging_Flamingos')
  	#flash[:notice] = gmail.inbox.count(:unread)
  	#flash[:notice] = gmail.logged_in?
		 #register your project with google at https://code.google.com/apis/console/, get the below constants

		 
		#first we send users to this URL:
		google_contacts_api_uri = 'https://www.google.com/m8/feeds'
		google_calendar_api_uri = 'http://www.google.com/calendar/feeds/default/allcalendars/full'
		 
		url = "https://accounts.google.com/o/oauth2/auth?scope=#{google_contacts_api_uri}+#{google_calendar_api_uri}&response_type=code&redirect_uri=#{REDIRECT_URI}&approval_prompt=force&client_id=#{CLIENT_ID}&lahl=en-US&from_login=1&access_type=offline"
		redirect_to url
		#the user approves the request and you get a code in your redirect URI 'http://YOUR_SITE/googleauth?code=YOUR_CODE

		 	
  end

  def exchange_token
  
  end
  def g_logout

  end

  def index
  	param = {
		  :code => params[:code],
		  :client_id => CLIENT_ID,
		  :client_secret => CLIENT_SECRET,
		  :redirect_uri => REDIRECT_URI,
		  :grant_type => 'authorization_code'
		}

			uri = URI.parse("https://accounts.google.com/o/oauth2/token")
			http = Net::HTTP.new(uri.host, uri.port)
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			http.use_ssl = true
			request = Net::HTTP::Post.new(uri.request_uri)
			request.content_type = "application/x-www-form-urlencoded"
			request.body = param.to_query
			#request.set_form_data(code: params[:code],
			#	:client_id => CLIENT_ID,
			 # :client_secret => CLIENT_SECRET,
			 # :redirect_uri => REDIRECT_URI,
			  #:grant_type => 'authorization_code')
			#response = http.request(request)
			#response = JSON.parse(response.body)
			#flash[:notice] = response["access_token"]


	    client = Google::APIClient.new
	    plus = client.discovered_api('plus')

	    # Initialize OAuth 2.0 client    
	    client.authorization.client_id = CLIENT_ID
	    client.authorization.client_secret = CLIENT_SECRET
	    client.authorization.redirect_uri = REDIRECT_URI
	    
	    client.authorization.scope = 'https://www.googleapis.com/auth/plus.me'

	    # Request authorization
	    redirect_uri = client.authorization.authorization_uri

	    # Wait for authorization code then exchange for token
	    client.authorization.code = params[:code]
	    client.authorization.fetch_access_token!

	    # Make an API call
	    @result = client.execute(
	      :api_method => plus.activities.list,
	      :parameters => {'collection' => 'public', 'userId' => 'me'}
	    )
	    #@result = @result.getContent()
	  end

	def check_gmail
		gmail = Gmail.connect(params[:email],params[:password])
  	flash[:notice] = "You have #{gmail.inbox.count(:unread)} unread emails"
		@emails = gmail.inbox.emails(:before => Date.parse("2012-10-01"))
	end

  def get_g_contacts
  end
end
