class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :address, :phone, :admin, :email, :birthday, :username, :password
  before_save :default_values
  
  def default_values
    self.username ||= ""
    self.first_name ||= ""
    self.last_name ||= ""
    self.address ||= ""
    self.email ||= ""
    self.password ||= "ConMan"
    self.admin ||= 0
    self.phone ||= 1234567890
    self.birthday ||= 11/11/11
    
  end

end
