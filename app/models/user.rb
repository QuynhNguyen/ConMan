class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :address, :phone, :admin, :email, :birthday, :username, :password, :show_fn, :show_ln, :show_addr, :show_phone, :show_email, :show_birthday
  before_save :default_values

  def default_values
    self.username ||= ""
    self.first_name ||= ""
    self.last_name ||= ""
    self.address ||= ""
    self.email ||= ""
    self.password ||= ""
    self.admin ||= 0
    self.phone ||= ""
    self.birthday ||= 11/11/11

#all shows are defualt to true
    self.show_fn ||= 1
    self.show_ln ||= 1
    self.show_addr ||= 1
    self.show_phone ||= 1
    self.show_email ||= 1
    self.show_birthday ||= 1
    
  end

# validates_length_of :username, :within => 6..20
# validates_length_of :password, :within => 6..20
# validates_length_of :first_name, :within => 1..50
# validates_length_of :last_name, :within => 1..50
# validates_length_of :email, :within => 4..50
# validates_length_of :address, :within => 1..100
# validates_length_of :phone, :within => 1..15

# validates_presence_of :username, :password, :first_name, :last_name, :email, :phone

# validates_uniqueness_of :username, :email

# validates_confirmation_of :password

  def self.authenticate(username,pass)
    user=find(:first, :conditions=>["username = ?", username])
    return nil if user.nil?
    return user if User.encrypt(pass)==user.password
    nil
  end

  def self.encrypt(pass)
    Digest::SHA512.hexdigest("KelYos"+pass+"YosKel")
  end
end
