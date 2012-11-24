class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :user_id
      t.string :fb_token
      t.string :twitter_token
      t.string :google_code

      t.timestamps
    end
  end
end
