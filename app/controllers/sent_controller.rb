class SentController < ApplicationController
	after_filter :mark_read, :only => [:show]

	def index
		if session[:id] != nil
		  @pm = PrivateMessage.where("from_user = '#{session[:id]}'")
		else
		  redirect_to log_in_index_path
		end
	end

	def show
		@private_message = PrivateMessage.find(params[:id])
	end
	
	def new
		#ignore
	end
	
	def create
		@user_id = User.where("username = '#{params[:private_message][:user]}'").first.id
		@private_message = PrivateMessage.create(message: params[:private_message][:message], date: DateTime.now, subject: params[:private_message][:subject], from_user: session[:id], user: @user_id, read: false)
		flash[:notice] = "Message was successfully sent!"
		redirect_to sent_index_path
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
		redirect_to sent_index_path
	end

	protected
		def mark_read
			@private_message.update_attribute(:read, true)
		end
end
