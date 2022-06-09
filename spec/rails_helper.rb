# require database cleaner at the top level
require 'database_cleaner'
require 'spec_helper'
require 'support/factory_bot'
require 'faker'
require 'rspec/rails'



ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)


Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # [...]
  # add `FactoryBot` methods
  config.include FactoryBot::Syntax::Methods

   Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }


  # start by truncating all the tables but then use the faster transaction strategy the rest of the time.
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  # start the transaction strategy as examples are run
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
  # [...]
end
