@wip
Feature: Show current version

  Background:
    * A git repository exists
    * The repo has the following commits:
      | Commit Message |
      | Commit #3      |
      | Commit #2      |
      | Commit #1      |


  Scenario Outline: Show current version
    Given '<Current Version>' is the latest release
     When I run "release"
        * '<Message>' should be displayed

    Examples:
      | Current Version | Message                           |
      | v1.2.0-final    | Current release is v1.2.0-final   |
      | v1.2.0-beta.2   | Current release is v1.2.0-beta.2  |
      | v1.2.0-alpha.3  | Current release is v1.2.0-alpha.3 |


