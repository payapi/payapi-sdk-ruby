require 'test_helper'
require 'payapi/authenticate'
require 'jwt'

class TestPayApiAuthentication < Minitest::Test
  def test_authentication_headers
    site = 'input.payapi.io'
    endpoint = "#{site}/auth/login"
    stub_request(:post, endpoint)
    params = {
      site: site,
      key: '123',
      password: 'password',
      secret: 'secret'
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

  def test_password_is_encrypted_using_secret
    site = 'input.payapi.io'
    secret = 'secret'
    password = 'password'
    api_key = '123'
    endpoint = "#{site}/auth/login"
    stub_request(:post, endpoint)

    params = {
      site: site,
      key: api_key,
      password: password,
      secret: secret
    }

    PayApi::Authenticate.new(params).call
    data = {apiKey: {key: api_key, 'password': password}}
    token = JWT.encode data, secret, 'HS512'

    assert_requested :post, endpoint,
      body: {
        'key': '123',
        'token': token,
      },
      times: 1
  end

end
