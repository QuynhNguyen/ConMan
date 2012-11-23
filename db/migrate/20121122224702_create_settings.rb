class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :user_id, unique: :true
      t.string :fb_token

      t.timestamps
    end
  end
end
