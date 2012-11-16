# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
users = User.create!([	{username: 'testuser1', first_name: 'first1', last_name: 'last1', address: 'address1', email: 'email1@email.email'},
						{username: 'testuser2', first_name: 'first2', last_name: 'last2', address: 'address2', email: 'email2@email.email'},
            {username: 'kelvin', password: User.encrypt('kelvin'), first_name: 'kelvin', last_name: 'kelvin', address: 'kelvin', email: 'kelvin@kelvin.com', phone: '8586101411'},
						{username: 'quynh', password: 'quynh', first_name: 'first2', last_name: 'last2', address: 'address2', email: 'email2@email.email'}])

PrivateMessage.create([	{from: users[0].id, message: 'user1 message1', date: DateTime.now, read: false, user: users[1].id, subject: 'subject1'},
						{from: users[1].id, message: 'user2 message1', date: DateTime.now, read: false, user: users[0].id, subject: 'subject2'}])
