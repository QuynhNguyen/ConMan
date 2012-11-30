class CreatePrivateMessages < ActiveRecord::Migration
  def up
	  create_table :private_messages do |t|
		t.integer	:user
	    t.integer	:from_user
	    t.string	:message
	    t.datetime	:date
	    t.boolean	:read
		t.string	:subject
  end
end

  def down
	  drop_table :private_messages
  end
end
