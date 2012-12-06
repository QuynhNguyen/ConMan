class ContactsController < ApplicationController
	CLIENT_ID = '178522046203.apps.googleusercontent.com'
	CLIENT_SECRET = 'jiTeMBbzOwNPrHfFaLirfIp1'
	REDIRECT_URI = 'http://localhost:3000/google/index'	
  def index
  	@user = User.find(session[:id])
  	@fb_contacts = get_fb_contacts()
    @google_contacts = []
    @twitter_contacts = []
  	if (@fb_contacts.count>0)
  		@google_contacts = get_google_contacts()
  	end
  	if (@google_contacts.count>0)
  		@twitter_contact = twitter_authorize()
  		##
  	end
  end

  def get_google_contacts
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
					flash[:notice] = "Please sign in your google account"
					redirect_to controller: :settings, action: :index			
					return []
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
				flash[:notice] = "Please sign in your google account"
				redirect_to controller: :settings, action: :index
				return []
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
			return @contacts
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
		@contacts = GoogleContact.find_all_by_user_id(@user.id)
		if (@contacts.count ==0)
			return []
		end
		return @contacts
  end

  def get_twitter_contacts
		@setting = Setting.find_by_user_id(session[:id])
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
		@twitter_contacts = TwitterContact.find_all_by_user_id(session[:id])
		return @twitter_contacts
  end

  def twitter_authorize
		@setting = Setting.find_by_user_id(session[:id])

		if (@setting)
			twitter_token = @setting.twitter_token
			if (!twitter_token)
				flash[:notice] = "Please sign in your twitter"
				redirect_to controller: :settings, action: :index
				return []
			end

		else
			flash[:notice] = "Please sign in your twitter account"
			redirect_to controller: :settings, action: :index
			return []
		end
		@contacts = get_twitter_contacts()

		return @contacts
	end

  def get_fb_contacts
		@user = User.find(session[:id])
		@setting ||= Setting.find_by_user_id(@user.id)

		if (@setting)
			@fb_token = @setting.fb_token
			if (!@fb_token)
				flash[:notice] = "Please sign in your facebook account"
				redirect_to controller: :settings, action: :index
				return []
			end
		else
			flash[:notice] = "Please sign in your facebook account"
			redirect_to controller: :settings, action: :index
			return []
		end

		@graph = Koala::Facebook::API.new(@setting.fb_token)	
		@friends = @graph.get_connections("me","friends")
		@contacts = FbContact.find_all_by_user_id(@user.id)

		if (@contacts.count >0)
			#check for new or old friends
			@f_live = []
			@f_db = []
			@friends.each do |f|
				@f_live << f["id"].to_i
			end
			@contacts.each do |c|
				@f_db << c.friend_id
			end
			#make new
			@f_live.each_with_index do |fid,index|
				unless (@f_db.include? fid)
					friend = FbContact.new(user_id: @user.id, friend_id: fid, name: @friends[index]["name"], photo: @graph.get_picture(fid))
					friend.save!
				end
			end
			#delete old
			@f_db.each_with_index do |fid,index|
				unless (@f_live.include? fid)
					friend = @contacts[index]
					friend.destroy
				end
			end
			#flash[:notice] = "you have friends"
			return @contacts
		end

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
		@contacts = FbContact.find_all_by_user_id(@user.id)
		if (@contacts.count == 0)
			return []
		end
		return @contacts

  end
end
