Feature: Signing in
  Background:
    Given I am at "/"

  Scenario: Clicking the sign in button
    When I click "Sign in"

    Then the Persona window appears
    And the Persona window is ready for login

  Scenario: Registering a new email address
    Given the Persona sign-in window is open

    When I provide the email address "newuser@example.org"

    Then I am prompted to create a password

  Scenario: Signing in
    Given the Persona sign-in window is open

    When I provide the email address "test@example.org"
    And I provide the password "password"
    And I submit my credentials

    Then I am signed in

  Scenario: An incorrect password does not complete sign-in
    Given the Persona sign-in window is open

    When I provide the email address "test@example.org"
    And I provide the password "wrongpassword"
    And I submit my credentials

    Then I am not signed in

# vim:ts=2:sw=2:et:tw=78
