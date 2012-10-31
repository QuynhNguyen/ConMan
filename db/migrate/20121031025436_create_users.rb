class CreateUsers < ActiveRecord::Migration
  def up
    create_table 'users' do |t|
      t.string  'first_name'
      t.string  'last_name'
      t.string  'address'
      t.integer 'phone'
      t.integer 'admin'
      t.string  'email'
      t.date    'birthday'
      t.string  'nickname'
    end
  end

  def down
    drop_table  'users'
  end
end
