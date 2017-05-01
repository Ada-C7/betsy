require 'simplecov'
SimpleCov.start


ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"  # for Colorized output

#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)


# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...

#setup method is run at the very beginning of the test suite and is run once
  # def setup
  #   #Turns on OmniAuth mocking in our tests«»
  #       #Tells the app that we'll accept any old auth_hash and don't have to go out to
  #       #github's servers during tests
  #   OmniAuth.config.test_mode = true
  # end
  #
  # def login(merchant)
  #     OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
  #     get auth_callback_path(:github)
  # end
  #
  # def mock_auth_hash(merchant)
  #   return{
  #     provider: merchant.oauth_provider,
  #     uid:merchant.oauth_uid,
  #     info:{
  #       email: merchant.email,
  #       nickname: merchant.username
  #     }
  #   }
  #
  # end

end
