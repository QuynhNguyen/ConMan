class CreateFbContacts < ActiveRecord::Migration
  def change
    create_table :fb_contacts do |t|
      t.integer :user_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.string :photo
      t.integer :friend_id

      t.timestamps
    end
  end
end
