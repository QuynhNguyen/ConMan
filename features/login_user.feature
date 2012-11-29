Feature: Login user

Scenario:
	Given I am on the login page
	When I fill in "Username" with "admin"
	And I fill in "Password" with "password"
	And I press "Log in"
	Then I should be on the profile page
