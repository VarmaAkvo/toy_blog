ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
# 引入Devise的相关测试辅助方法
class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  # 用于在测试中通过基础身份验证
  def headers_hash
    { headers:
      { Authorization:
        ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'admin')
      }
    }
  end
end
