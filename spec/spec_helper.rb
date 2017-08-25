require "bundler/setup"
require 'coveralls'

Coveralls.wear!

require "bcoin/client"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def load_mock!(name)

    path = __dir__ + '/mocks/'
    JSON.load(File.read(path + name))
  end
end
