class PrivateMessage < ActiveRecord::Base
	belongs_to :user
	attr_accessible :from, :message, :date, :read, :user
end
