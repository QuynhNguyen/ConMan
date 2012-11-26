class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string    :username
      t.string    :password
      t.string    :first_name
      t.string    :last_name
      t.string    :email
      t.string    :address
      t.integer   :phone
      t.integer   :admin
      
      t.integer   :show_fn
      t.integer   :show_ln
      t.integer   :show_addr
      t.integer   :show_phone
      t.integer   :show_email

      t.timestamps
    end
  end

  def down
    drop_table  :users
  end
end
