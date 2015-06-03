require 'test_helper'
require 'payapi/authenticate'

class TestPayapi < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Payapi::VERSION
  end

  def test_authentication
    site = 'input.payapi.io'
    endpoint = '/auth/login'
    stub_request(:any, "#{site}#{endpoint}")
    params = {
      site: site,
      api_key: '123',
      password: 'password',
      private_key: 'private_key'
    }
    authenticate = PayApi::Authenticate.new(params).call
  end

end
