class ContactsController < ApplicationController
  def index
  	@user = User.find(session[:id])
  	@fb_contacts = FbContact.find_all_by_user_id(@user.id)
  	@google_contacts = GoogleContact.find_all_by_user_id(@user.id)
  	@twitter_contacts = TwitterContact.find_all_by_user_id(@user.id)
  end
end
