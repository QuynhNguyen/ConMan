class SearchesController < ApplicationController
	def index
   		@result = User.where('first_name LIKE ? OR username LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%").all
	end
end
