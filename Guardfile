# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'cucumber', :cli => "--require features/ --format progress", :all_after_pass => true do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})                      { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
  watch('spec/factories.rb')                            { "cucumber" }
  watch('rdt')                                          { 'features' }
  watch(%r{^lib/(.+)$})                                 { |m| Dir[File.join("**/#{m[1]}/*.feature")][0] || 'features' }
end