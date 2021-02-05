# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
require 'faker'
require 'json_matchers/rspec'
require 'pry'
require 'truemail'
require 'truemail/rspec'
require 'dns_mock/test_framework/rspec'
require 'webmock/rspec'

SimpleCov.start
JsonMatchers.schema_root = 'spec/support/schemas'

rspec_custom = File.join(File.dirname(__FILE__), 'support/**/*.rb')
Dir[File.expand_path(rspec_custom)].each { |file| require file unless file[/\A.+_spec\.rb\z/] }

RSpec::Mocks.configuration.allow_message_expectations_on_nil = true
RSpec.configure do |config|
  config.include Truemail::RSpec
  config.include Truemail::IpifyHelper
  config.include DnsMock::TestFramework::RSpec::Helper
  config.order = :random
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.before { Truemail.reset_configuration! }

  ::Kernel.srand(config.seed)
end
