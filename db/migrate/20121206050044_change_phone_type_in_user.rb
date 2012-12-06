class ChangePhoneTypeInUser < ActiveRecord::Migration
  def up
  	change_column :users, :phone, :bigint
  end

  def down
  	change_column :users, :phone, :int
  end
end
