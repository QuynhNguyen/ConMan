class TwitterContact < ActiveRecord::Base
  attr_accessible :friend_id, :name, :photo, :screen_name, :user_id
  validates_uniqueness_of(:screen_name, :scope => :user_id)
end
