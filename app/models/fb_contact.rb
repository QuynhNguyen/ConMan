class FbContact < ActiveRecord::Base
  attr_accessible :email, :first_name, :friend_id, :last_name, :name, :phone_number, :photo, :user_id
  validates :friend_id, uniqueness: :true
end
