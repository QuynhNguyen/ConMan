class CreateTwitterContacts < ActiveRecord::Migration
  def change
    create_table :twitter_contacts do |t|
      t.string :name
      t.string :screen_name
      t.string :photo
      t.integer :user_id
      t.integer :id

      t.timestamps
    end
  end
end
