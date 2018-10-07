require 'chefspec'
require 'chefspec/berkshelf'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true
  config.example_status_persistence_file_path = 'spec/spec_state'
end

at_exit { ChefSpec::Coverage.report! }
