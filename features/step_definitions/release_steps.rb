#======================
# GIVENs
#======================

Given /^[Aa] git repository exists$/ do
  init_git_repo
  run "git init && git status"
  raise "Couldn't create git repo for testing!" if $? != 0
  @total_commits = 0
end

Given /^The repo has the following commits:$/ do |commits|
  existing_commits = @total_commits
  commits = commits.hashes.map { |hash| hash.symbolize_keys }
  create_commits(commits)

  @total_commits = run("git log --pretty=format:'-'").count('-')
  @total_commits.should == commits.length + existing_commits
end

Given /^I've added the following commits to the repo$/ do |commits|
  existing_commits = @total_commits

  commits = commits.hashes.map { |hash| hash.symbolize_keys }
  create_commits(commits)

  @total_commits = run("git log --pretty=format:'-'").count('-')
  @total_commits.should == commits.length + existing_commits
end

#======================
# WHENs
#======================

When /^I run "([^"]*)"$/ do |command|
  run "#{command}"
end

#======================
# THENs
#======================

Then /^a new commit should be logged to the repo$/ do
  run("git log --pretty=format:'-'").count('-').should == @total_commits + 1
end

Then /^the commit message should be:$/ do |expected_msg|
  commit_msg = ''
  run("git log -1").split(/\n\n/)[1].each_line do
    |l| commit_msg << l.gsub(/^[ ]+/, "").gsub(/(?<=-- )(\w)+/, "(hash)")
  end
  commit_msg.strip.should == expected_msg.strip
end

Then /^'(.+)' should be tagged in the repo$/ do |version_string|
  run "git show #{version_string} 2>/dev/null"
  raise "Tag '#{version_string}' could not be found in the repo" if $? != 0
end

Then /^the version\.yml file should contain:$/ do |version|
  expected_version = version.hashes[0]
  saved_version = YAML.load_stream(run('cat version.yml'))[0]
  expected_version.each_key do |key|
    saved_version[key].to_s.should == expected_version[key]
  end
end