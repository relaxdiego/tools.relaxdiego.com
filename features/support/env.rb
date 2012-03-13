# SimpleCov doesn't work since the tests run the commands in a separate process.
# I still need to re-design the tests such that they run the commands on the same process.
# Or perhaps just call the class methods directly from the step definitions.
# An issue to resolve in that case is how to make sure the methods act on
# the test_git_repo and not on the repo for tools.relaxdiego.com

# require 'simplecov'
# SimpleCov.coverage_dir 'coverage'
# SimpleCov.start do
#   add_filter 'features'
# end
# require File.expand_path('../../../lib/release', __FILE__)