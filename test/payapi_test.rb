require 'test_helper'
require 'payapi/authenticate'
require 'jwt'

class TestPayapi < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Payapi::VERSION
  end

  def test_authentication_headers
    site = 'input.payapi.io'
    endpoint = "#{site}/auth/login"
    stub_request(:post, endpoint)
    params = {
      site: site,
      key: '123',
      password: 'password',
      private_key: 'private_key'
    }
    PayApi::Authenticate.new(params).call
    assert_requested :post, endpoint,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'alg': 'HS512'
      },
      times: 1
  end

  def test_password_is_encrypted_using_private_key
    site = 'input.payapi.io'
    private_key = 'private_key'
    password = 'password'
    api_key = '123'
    endpoint = "#{site}/auth/login"
    stub_request(:post, endpoint)

    params = {
      site: site,
      key: api_key,
      password: password,
      private_key: private_key
    }

    PayApi::Authenticate.new(params).call
    data = {user: {key: api_key, 'password': password}}
    token = JWT.encode data, private_key, 'HS512'

    assert_requested :post, endpoint,
      body: {
        'api_key': '123',
        'token': token,
      },
      times: 1
  end

end
