require 'rest-client'
require 'jwt'
module PayApi

  class Payment
    attr_reader :params, :options, :site, :secret, :token

    #params = {
    #  token: <authentication token>,
    #  secret: <your api key secret>,
    #  site: <payapi site you are connecting to>,
    #  cc_ccv2: <credit card ccv2>,
    #  cc_number: <credit card number>,
    #  cc_holder_name: <name of credit card owner>,
    #  cc_expires: <expiration date of credit card in mm/yy format>,
    #  success_callback: <callback url for a successful payment>,
    #  failure_callback: <callback url for a failed payment>,
    #  cancel_callback: <callback url for a cancelled payment>
    #}
    #options = {
    #  ip_address: <ip address of client who entered credit card details>
    #}
    def initialize(params, options)
      @params = params
      @options = options
      @site = params.fetch(:site)
      @secret = params.fetch(:secret)
      @token = params.fetch(:token)
      @params.delete(:site)
      @params.delete(:secret)
      @params.delete(:token)
      RestClient.add_before_execution_proc do |req, params|
        req['alg'] = 'HS512'
      end
    end

    def call
      resource = RestClient::Resource.new(site, { headers: {content_type: :json, accept: :json }})
      data = {params: params, options: options}
      data = JWT.encode data, secret, 'HS512'
      params = {
        token: token,
        data: data
      }.to_json
      response = resource['/api/payments'].post params
    end
  end
end

