require 'test_helper'
require 'payapi/authenticate'
require 'payapi/payment'
require 'jwt'

class TestPayApiPayment < Minitest::Test
  attr_reader :token, :site, :secret, :endpoint, :params, :options

  def setup
    @site = 'input.payapi.io'
    @endpoint = "#{@site}/api/payments"
    @secret = 'super secret'
    @token = 'dummy token'
    # params are mandatory
    @params = {
      token: token,
      secret: secret,
      site: site,
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
    @options = {
    }
  end

  def test_required_parameters
    stub_request(:post, @endpoint)
    PayApi::Payment.new(params, options).call
    params.delete(:site)
    params.delete(:secret)
    params.delete(:token)
    data = {params: params, options: options}
    data = JWT.encode data, secret, 'HS512'
    assert_requested :post, endpoint,
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

end

