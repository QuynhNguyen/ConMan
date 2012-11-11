# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121103045152) do

  create_table "private_messages", :force => true do |t|
    t.integer  "user"
    t.integer  "from"
    t.string   "message"
    t.datetime "date"
    t.boolean  "read"
    t.string   "subject"
  end

  create_table "statuses", :force => true do |t|
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "address"
    t.integer  "phone"
    t.integer  "admin"
    t.datetime "birthday"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end