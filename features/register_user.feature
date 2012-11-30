Feature: Register user

Scenario:
	Given I am on the login page
	When I follow "Register"
	Then I should be on the new user page
	When I fill in "Username" with "admin"
	And I fill in "Password" with "password"
	And I fill in "Re-type password" with "password"
	And I fill in "First Name" with "first"
	And I fill in "Last Name" with "last"
	And I fill in "Email" with "project_conman@gmail.com"
	And I fill in "Address" with "UCSD"
	And I fill in "Phone" with "123456789"
	And I press "Register User"
	Then I should be on the login page
