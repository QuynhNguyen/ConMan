Feature: Login user

Scenario:
	Given I am on the login page
	When I fill in "Username" with "admin"
	And I fill in "Password" with "password"
	And I press "Log In"
	Then I should be on admin's profile page 
	And I should see "Hello, first"
