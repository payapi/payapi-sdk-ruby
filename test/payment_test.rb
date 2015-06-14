require 'test_helper'
require 'payapi/authenticate'
require 'payapi/payment'
require 'jwt'

class TestPayApiPayment < Minitest::Test
  attr_reader :token, :site, :secret, :endpoint

  def test_required_parameters
    @site = 'input.payapi.io'
    @endpoint = "#{@site}/payments"
    @secret = 'super secret'
    stub_request(:post, @endpoint)
    # params are mandatory
    params = {
      token: token,
      secret: secret,
      site: @site,
      cc_ccv2: '1234',
      cc_number: '1234123412341234',
      cc_holder_name: 'John Smith',
      cc_expires: '12/19',
      success_callback: 'http://lvh.me/payment_success',
      failure_callback: 'http://lvh.me/payment_failure',
      cancel_callback: 'http://lvh.me/payment_cancelled'
    }
    # options are optional, chiefly adding to fraud check
    # coverage and score
    options = {
    }
    data = {params: params, options: options}
    data = JWT.encode data, secret, 'HS512'
    PayApi::Payment.new(params, options).call
    assert_requested :post, @endpoint,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'alg': 'HS512'
      },
      body: {
        token: token,
        data: data
      },
      times: 1
  end

  #def test_password_is_encrypted_using_secret
  #  site = 'input.payapi.io'
  #  secret = 'secret'
  #  password = 'password'
  #  api_key = '123'
  #  endpoint = "#{site}/auth/login"
  #  stub_request(:post, endpoint)

  #  params = {
  #    site: site,
  #    key: api_key,
  #    password: password,
  #    secret: secret
  #  }

  #  PayApi::Authenticate.new(params).call
  #  data = {apiKey: {key: api_key, 'password': password}}
  #  token = JWT.encode data, secret, 'HS512'

  #  assert_requested :post, endpoint,
  #    body: {
  #      'key': '123',
  #      'token': token,
  #    },
  #    times: 1
  #end

end

