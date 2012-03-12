# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'cucumber', :cli => "--require features/ --format progress", :all_after_pass => false do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})                      { 'features --tags @wip' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| (Dir[File.join("**/#{m[1]}.feature")][0] || 'features') + ' --tags @wip' }
  watch(%r{^release$})                                  { |m| 'features --tags @wip' }
end