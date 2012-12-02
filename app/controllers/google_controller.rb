require 'net/http'
require 'net/https'
require 'uri'
require "json"
require 'nokogiri'
require 'gmail'

class GoogleController < ApplicationController
	CLIENT_ID = '178522046203.apps.googleusercontent.com'
	CLIENT_SECRET = 'jiTeMBbzOwNPrHfFaLirfIp1'
	REDIRECT_URI = 'http://localhost:3000/google/index'

  def g_login
   	@user = User.find(session[:id])
		@setting ||= Setting.find_by_user_id(@user.id)

		google_contacts_api_uri = 'https://www.google.com/m8/feeds'
		google_calendar_api_uri = 'http://www.google.com/calendar/feeds/default/allcalendars/full'
		plus_uri = "https://www.googleapis.com/auth/plus.me" 
		url = "https://accounts.google.com/o/oauth2/auth?approval_prompt=force&scope=#{plus_uri}+#{google_contacts_api_uri}+#{google_calendar_api_uri}&response_type=code&redirect_uri=#{REDIRECT_URI}&client_id=#{CLIENT_ID}&lahl=en-US&from_login=1&access_type=offline"
		redirect_to url

  end
  
  def index
  	@user = User.find(session[:id])
	@setting ||= Setting.find_by_user_id(@user.id)

	uri = URI.parse("https://accounts.google.com/o/oauth2/token")
	http = Net::HTTP.new(uri.host, uri.port)
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	http.use_ssl = true
	request = Net::HTTP::Post.new(uri.request_uri)
	request.content_type = "application/x-www-form-urlencoded"


	if (@setting)
		if (params[:code])
			if (@setting.google_code)
				param = {
				  refresh_token: @setting.google_code,
				  client_id: CLIENT_ID,
				  client_secret: CLIENT_SECRET,
				  grant_type: 'refresh_token'
				}
	
				request.body = param.to_query
				@response = JSON.parse(http.request(request).body)
				flash[:notice] = "using refresh token"
			else
				param = {
				  code: params[:code],
				  client_id: CLIENT_ID,
				  client_secret: CLIENT_SECRET,
				  redirect_uri: REDIRECT_URI,
				  grant_type: 'authorization_code'
				}
				request.body = param.to_query
				@response = JSON.parse(http.request(request).body)
				@setting.google_code = @response["refresh_token"]
				@setting.save!
				flash[:notice] = "update refresh token"
			end
		else
			if (@setting.google_code)
				param = {
				  refresh_token: @setting.google_code,
				  client_id: CLIENT_ID,
				  client_secret: CLIENT_SECRET,
				  grant_type: 'refresh_token'
				}
				request.body = param.to_query
				@response = JSON.parse(http.request(request).body)
				flash[:notice] = "using refresh token"
			else
				#flash[:notice] = "Please sign in your google account"
				redirect_to controller: :settings, action: :index			
				return
			end
		end

	else
		if (params[:code])
			param = {
			  code: params[:code],
			  client_id: CLIENT_ID,
			  client_secret: CLIENT_SECRET,
			  redirect_uri: REDIRECT_URI,
			  grant_type: 'authorization_code'
			}
			request.body = param.to_query
			@response = JSON.parse(http.request(request).body)
			@setting = Setting.new(user_id: @user.id, google_code: @response["refresh_token"])
			@setting.save!
			#flash[:notice] = "create refresh token"
		else
			#flash[:notice] = "Please sign in your google account"
			redirect_to controller: :settings, action: :index
			return
		end
	end

	@token = @response["access_token"]
	@url = "https://www.google.com/m8/feeds/contacts/default/full?access_token=#{@token}"
	@doc = Nokogiri::XML(open(@url))
	@titles = []
	@emails = @doc.xpath("//gd:email/@address")


	@contacts = GoogleContact.find_all_by_user_id(@user.id)
	if (@contacts.count >0)
		titles = []
		ids = []
		@contact_db_email = []
		@live_email = []
		@emails.each do |email|
			@live_email << email.to_s
		end

		#get existing contact list
		@contacts.each do |contact|
			@contact_db_email << contact.email
		end

		#get titles
		@doc.css("entry").each do |e|
			titles << e.css("title")[0].inner_text
		end

		#get live result IDs
		contacts_id = @doc.search("id")
		contacts_id.shift
		contacts_id.each do |id|
			ids  << id.inner_text[/[a-zA-Z0-9]*$/]
		end

		#remove old contacts
		@live_email.each_with_index do |email, index|
			unless (@contact_db_email.include? email)
				contact = GoogleContact.new(user_id: @user.id, friend_id: ids[index], email: @emails[index].to_s, name: titles[index])
				contact.save!
			end
		end
		@contact_db_email.each_with_index do |email, index|
			unless (@live_email.include? email)
				@contacts[index].destroy
			end
		end
		return
	end


	@doc.css("entry").each do |e|
		@titles << e.css("title")[0].inner_text
	end

	@id = []
	@contacts_id = @doc.search("id")
	@contacts_id.shift
	@contacts_id.each do |id|
		@id  << id.inner_text[/[a-zA-Z0-9]*$/]
	end


	@titles.each_with_index do |t,index|
		contact = GoogleContact.new(user_id: @user.id, friend_id: @id[index], email: @emails[index].to_s, name: t)
		contact.save!
	end

  end
 
 	def insert_contact
 		@token = params[:access_token]
  		@id = params[:id]

		uri = URI.parse("https://www.google.com/m8/feeds/contacts/default/full")
		http = Net::HTTP.new(uri.host, uri.port)
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		http.use_ssl = true
		request = Net::HTTP::Post.new(uri.request_uri)
		request.content_type = "application/json"
		request["Gdata-version"] = '3.0'
		request.set_form_data(access_token: @token,
			name: 'minh',
			address: 'assa@as.com')
		@response = http.request(request).body
		
 	end


  def delete_contact
  	@token = params[:access_token]
  	@id = params[:id]

	uri = URI.parse("https://www.google.com/m8/feeds/contacts/default/full/")
	http = Net::HTTP.new(uri.host, uri.port)
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	http.use_ssl = true
	request = Net::HTTP::Delete.new(uri.path+"#{@id}&access_token=#{@token}")
	request.content_type = "application/json"
	request["Gdata-version"] = '3.0'
	@response = (http.request(request).code)
	end


  def get_g_contacts
  end
end
