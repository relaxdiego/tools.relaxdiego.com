Feature: Finalize a Version

  Background:
    * A git repository exists
    * The repo has the following commits:
      | Commit Message |
      | Commit #3      |
      | Commit #2      |
      | Commit #1      |


  Scenario Outline: Finalize a version
    Given '<Old Version>' is the latest release
      And I've added the following commits to the repo
      | Commit Message          |
      | Refactor business logic |
      | Add a User model        |
     When I run "release finalize"
     * a new commit should be logged to the repo
     * the commit message should be:
       """
       Update version to <New Version>
       -------------------------------
       Changes since <Old Version>:
        - (hash) Refactor business logic
        - (hash) Add a User model
       """
     * '<Old Version>' should be tagged in the repo
     * the version.yml file should contain '<New Version>'

    Examples:
      | Old Version     | New Version   |
      | v9.3.0-alpha.1  | v9.3.0-final  |
      | v10.7.0-beta.2  | v10.7.0-final |
      | v10.5.0-alpha.2 | v10.5.0-final |


  Scenario Outline: Attempt to finalize an already finalized release
    Given '<Previous Release>' is the latest release
      And I've added the following commits to the repo
      | Commit Message          |
      | Refactor business logic |
      | Add a User model        |
     When I run "release finalize"
        * an error message '<Message>' should be displayed
        * a new commit should not be logged to the repo
        * no new tag should be added to the repo
        * the version.yml file should not be updated

    Examples:
      | Previous Release | Message                                                                                         |
      | v1.2.3-final     | ERROR: The current version is already final. Try creating a new major or minor version instead. |
      | v9.2.0-final     | ERROR: The current version is already final. Try creating a new major or minor version instead. |


