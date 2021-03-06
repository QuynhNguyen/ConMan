Feature: Password Recovery

Scenario:
	Given I am on the login page
	When I follow "Forgot Password"
	Then I should be on the password recovery page
	When I fill "email" with project_conman@gmail.com
	And I press "Send"
	Then I should be on the login page
	And I should see "We have sent the password to your phone. Please change your password ASAP."

