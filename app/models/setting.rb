class Setting < ActiveRecord::Base
  attr_accessible :fb_token, :google_code, :twitter_token, :user_id, :twitter_secret
  validate :user_id, uniqueness: :true
end
