Feature: Release a Version

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
     When I run "release <Options>"
        * a new commit should be logged to the repo
        * the commit message should be:
          """
          Update version to <Resulting Version>
          -------------------------------
          Changes since the first commit:
           - (hash) Refactor business logic
           - (hash) Add a User model
           - (hash) Commit #3
           - (hash) Commit #2
           - (hash) Commit #1
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


  Scenario Outline: Attempt to release an invalid version
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
      | Previous Release  | Options       | Message                                                                                         |
      | v1.2.3-final      | patch alpha.1 | ERROR: Patch releases are supposed to be stable and, therefore, final. |
      | v1.2.5-final      | patch beta.9  | ERROR: Patch releases are supposed to be stable and, therefore, final. |
      | v2.9.0-final      | patch gamma.5 | ERROR: Patch releases are supposed to be stable and, therefore, final. |
      | v9.3.0-alpha.1    | patch         | ERROR: You can't increment the patch version until you finalize the current release. |
      | v10.7.0-beta.2    | major beta.1  | ERROR: You can't increment the major version until you finalize the current release. |
      | v10.5.0-alpha.2   | minor final   | ERROR: You can't increment the minor version until you finalize the current release. |
