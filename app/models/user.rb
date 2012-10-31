class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :address, :phone, :admin, :email, :birthday, :nickname
end
