Feature: Release a Major Version

  Background:
    * A git repository exists
    * The repo has the following commits:
      | Commit Message |
      | Commit #3      |
      | Commit #2      |
      | Commit #1      |


  Scenario: Release a pre-release version
    Given I've added the following commits to the repo
      | Commit Message          |
      | Refactor business logic |
      | Add a User model        |
     When I run "rdt release major beta.1"
     Then a new commit should be logged to the repo
      And the commit message should be:
      """
      Update version to v1.0.0-beta.1
      -------------------------------
      Changes since the first commit:
      -- (hash) Refactor business logic
      -- (hash) Add a User model
      -- (hash) Commit #3
      -- (hash) Commit #2
      -- (hash) Commit #1
      """
      And 'v1.0.0-beta.1' should be tagged in the repo