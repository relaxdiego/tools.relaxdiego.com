Feature: Release a Major Version

  Background:
    * A git repository exists
    * The repo has the following commits:
      | Commit Message |
      | Commit #3      |
      | Commit #2      |
      | Commit #1      |


  Scenario Outline: Release a version
    Given I've added the following commits to the repo
      | Commit Message          |
      | Refactor business logic |
      | Add a User model        |
     When I run "rdt release <Options>"
        * a new commit should be logged to the repo
        * the commit message should be:
          """
          Update version to <Resulting Version>
          -------------------------------
          Changes since the first commit:
          -- (hash) Refactor business logic
          -- (hash) Add a User model
          -- (hash) Commit #3
          -- (hash) Commit #2
          -- (hash) Commit #1
          """
        * '<Resulting Version>' should be tagged in the repo
        * the version.yml file should contain '<Resulting Version>'

    Examples:
      | Options       | Resulting Version |
      | major beta.1  | v1.0.0-beta.1     |
      | minor alpha.1 | v0.1.0-alpha.1    |
      | major final   | v1.0.0-final      |
      | minor final   | v0.1.0-final      |
      | patch         | v0.0.1-final      |