class ProfilesController < ApplicationController

	skip_filter :login
	#GET /profiles
	def index
		#If we leave this as default, Rails will automatically
		#render index.html.erb
		@User = User.find(params[:id])
		@setting = Setting.find_by_user_id(@User.id)
		if (@setting)
			begin
				@fb_token = !@setting.fb_token.empty?
				@google_code = !@setting.google_code.empty?
				@twitter_contact = TwitterContact.find_all_by_user_id(@User.id).count > 0
			rescue Exception
			end
		end
	end

	def socialnetwork
		@fb_friend_images = []
		@fb_friends_list = flash[:fb_friends_list]
		if (flash[:fb_friends_images])
			flash[:fb_friends_images].each do |image|
				@fb_friend_images << image
			end

		end
		redirect_to "fb/index"
	end

end
