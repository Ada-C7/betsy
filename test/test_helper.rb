require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"

Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  fixtures :all

  def setup
    #Make OmniAuth accept mockdata in tests
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(user)
    return {
            provider: user.oauth_provider,
            uid: user.oauth_uid,
            info: {
                  email: user.email,
                  nickname: user.username
                  }
           }
  end

  def login(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    get auth_callback_path
  end

  def get_current_order
    post current_order
  end
  
  def set_up_order(product)
    post product_add_product_path(product.id)
  end
end
