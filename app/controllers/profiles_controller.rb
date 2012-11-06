class ProfilesController < ApplicationController
	#GET /profiles
	def index
		#If we leave this as default, Rails will automatically
		#render index.html.erb
		@User = User.select("first_name, last_name, username, email, phone").find(params[:id])
	end 
end
