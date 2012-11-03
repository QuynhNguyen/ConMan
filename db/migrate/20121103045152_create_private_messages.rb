class CreatePrivateMessages < ActiveRecord::Migration
  def up
	  create_table :private_messages do |t|
	    t.integer	:from
	    t.string	:message
	    t.datetime	:date
	    t.integer	:user
	    t.boolean	:read
  end
end

  def down
	  drop_table :private_messages
  end
end
