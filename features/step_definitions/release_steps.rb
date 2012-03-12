#======================
# GIVENs
#======================

Given /^[Aa] git repository exists$/ do
  init_git_repo
  run "git init && git status"
  raise "Couldn't create git repo for testing!" if $? != 0
  @original_commit_count = run("git log --pretty=format:'-' 2>/dev/null").count('-')
  @original_tags = run("git tag").count("\nv")
  @original_version = YAML.load_stream(run("cat version.yml 2>/dev/null"))
end

Given /^The repo has the following commits:$/ do |commits|
  existing_commits = @original_commit_count
  commits = commits.hashes.map { |hash| hash.symbolize_keys }
  create_commits(commits)

  @original_commit_count = run("git log --pretty=format:'-'").count('-')
  @original_commit_count.should == commits.length + existing_commits
end

Given /^I've added the following commits to the repo$/ do |commits|
  existing_commits = @original_commit_count

  commits = commits.hashes.map { |hash| hash.symbolize_keys }
  create_commits(commits)

  @original_commit_count = run("git log --pretty=format:'-'").count('-')
  @original_commit_count.should == commits.length + existing_commits
end

Given /^'v(\d+)\.(\d+)\.(\d+)-(.+)' is the latest release$/ do |major, minor, patch, pre|
  ver = {}
  ver['major'] = major
  ver['minor'] = minor.to_i - 1
  ver['patch'] = patch
  ver['pre-release'] = 'final'

  run "echo \"#{YAML.dump(ver)}\" > version.yml"
  run "release minor #{pre}"
  @original_commit_count = run("git log --pretty=format:'-'").count('-')
  @original_tags = run("git tag").count("\nv")
  @original_version = YAML.load_stream(run("cat version.yml"))
end

#======================
# WHENs
#======================

When /^I run "release (major .+|minor .+|patch.*|help|pre.*|finalize)"$/ do |options|
  @message = run "release #{options}"
end

When /^I run "release"$/ do
  @message = run "release"
end

#======================
# THENs
#======================

Then /^a new commit should be logged to the repo$/ do
  run("git log --pretty=format:'-'").count('-').should == @original_commit_count + 1
end

Then /^the commit message should be:$/ do |expected_msg|
  commit_msg = ''
  divider_length = 0
  run("git log -1").split(/\n\n/)[1].each_line do |l|
    divider_length = l.strip.length if l.strip.match(/^Update version/)
    commit_msg << l.gsub(/^[ ]{4}/, "").gsub(/(?<= - )(\w)+/, "(hash)")
  end
  expected_msg.gsub!(/(-----+\n)/, '-' * divider_length + "\n")

  commit_msg.strip.should == expected_msg.strip
end

Then /^'(.+)' should be tagged in the repo$/ do |version_string|
  run "git show #{version_string} 2>/dev/null"
  raise "Tag '#{version_string}' could not be found in the repo" if $? != 0
end

Then /^the version\.yml file should contain '(.+)'$/ do |version_string|
  ver = YAML.load_stream(run('cat version.yml'))[0]
  saved_version = "v#{ ver['major'] }.#{ ver['minor'] }.#{ ver['patch'] }-#{ ver['pre-release'] }"
  saved_version.should == version_string
end

Then /^an error message '(.+)' should be displayed$/ do |message|
  message << "\nTry `release help` for more information.\n"
  @message.should == message
end

Then /^a new commit should not be logged to the repo$/ do
  run("git log --pretty=format:'-'").count('-').should == @original_commit_count
end

Then /^no new tag should be added to the repo$/ do
  run("git tag").count("\nv").should == @original_tags
end

Then /^the version\.yml file should not be updated$/ do
  YAML.load_stream(run('cat version.yml')).should == @original_version
end

Then /^the the help message should be displayed$/ do
  @message.match(/ +Usage: /).length.should >= 1
end

Given /^'(.+)' should be displayed$/ do |message|
  @message.strip.should == message
end
