class PrivateMessage < ActiveRecord::Base
	attr_accessible :from, :message, :date, :read, :user, :subject
end
