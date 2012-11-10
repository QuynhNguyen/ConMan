class PrivateMessagesController < ApplicationController
	def index
		@pm = PrivateMessage.all
	end

	def show
		@private_message = PrivateMessage.find(params[:id])
	end
	
	def new
		#ignore
	end
	
	def create
		@user = User.where("username = '#{params[:private_message][:user]}'").first
		#@private_message = PrivateMessage.create(message: params[:private_message][:message], subject: params[:private_message][:subject], user: @user.id)
		flash[:notice] = "Message was successfully sent!"
		redirect_to private_messages_path
	end

	def edit
		#ignore
	end

	def update
		#ignore
	end

	def destroy
		@private_message = PrivateMessage.find(params[:id])
		@private_message.destroy
		flash[:notice] = "Message deleted."
		redirect_to private_messages_path
	end
end
