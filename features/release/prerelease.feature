Feature: Release a Pre-release

  Background:
    * A git repository exists
    * The repo has the following commits:
      | Commit Message |
      | Commit #3      |
      | Commit #2      |
      | Commit #1      |


  Scenario Outline: Release a valid pre-release
    Given 'v1.2.0-alpha.1' is the latest release
      And I've added the following commits to the repo
      | Commit Message          |
      | Refactor business logic |
      | Add a User model        |
     When I run "release <Options>"
        * a new commit should be logged to the repo
        * the commit message should be:
          """
          Update version to <Resulting Version>
          -------------------------------
          Changes since v1.2.0-alpha.1:
           - (hash) Refactor business logic
           - (hash) Add a User model
          """
        * '<Resulting Version>' should be tagged in the repo
        * the version.yml file should contain '<Resulting Version>'

    Examples:
      | Options     | Resulting Version |
      | pre alpha.2 | v1.2.0-alpha.2    |
      | pre beta.2  | v1.2.0-beta.2     |


  Scenario Outline: Release an invalid pre-release
    Given '<Previous Release>' is the latest release
      And I've added the following commits to the repo
      | Commit Message          |
      | Refactor business logic |
      | Add a User model        |
     When I run "release <Options>"
        * an error message '<Message>' should be displayed
        * a new commit should not be logged to the repo
        * no new tag should be added to the repo
        * the version.yml file should not be updated

    Examples:
      | Previous Release | Options     | Message                                                                                         |
      | v1.2.3-final     | pre beta.4  | ERROR: Ambiguous command. Try `release major beta.4` or `release minor beta.4`          |
      | v1.2.3-final     | pre alpha.9 | ERROR: Ambiguous command. Try `release major alpha.9` or `release minor alpha.9`          |
      | v1.2.0-beta.2    | pre final   | ERROR: Pre-release must be alpha, beta, or gamma followed by a '.' and a number. (e.g. beta.10) |
      | v1.2.0-alpha.3   | pre         | ERROR: You have to supply a second argument with pre. (e.g. `release pre gamma2`) |


