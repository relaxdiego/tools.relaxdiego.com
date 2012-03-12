Feature: Show Help

  Scenario: Show Help
     When I run "release help"
     Then the the help message should be displayed