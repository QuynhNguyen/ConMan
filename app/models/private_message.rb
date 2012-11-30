class PrivateMessage < ActiveRecord::Base
	attr_accessible :from_user, :message, :date, :read, :user, :subject
end
