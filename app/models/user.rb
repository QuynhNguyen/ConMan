class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :address, :phone, :admin, :email, :birthday, :username, :password
  before_save :default_values
  
  def default_values
    self.admin ||= 0
  end

end
