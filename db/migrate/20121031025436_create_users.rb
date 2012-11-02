class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string    :nickname
      t.string     :password
      t.string    :first_name
      t.string    :last_name
      t.string    :email
      t.string    :address
      t.integer   :phone
      t.integer   :admin
      t.datetime  :birthday

      t.timestamps
    end
  end

  def down
    drop_table  :users
  end
end
