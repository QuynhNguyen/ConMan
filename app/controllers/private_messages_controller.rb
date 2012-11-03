class PrivateMessagesController < ApplicationController
	def index
		@pm = PrivateMessage.all
	end
	
	def new
		#ignore
	end
	
	def create
		@private_message = PrivateMessage.create(params[:private_message])
	end
end
