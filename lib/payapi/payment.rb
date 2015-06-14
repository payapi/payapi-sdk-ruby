require 'rest-client'
require 'jwt'
module PayApi

  class Payment
    attr_reader :params, :options

    #params = {
    #  token: <authentication token>,
    #  secret: <your api key secret>,
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
      RestClient.add_before_execution_proc do |req, params|
        req['alg'] = 'HS512'
      end
    end

    def call
      site = params.fetch(:site)
      resource = RestClient::Resource.new(site, { headers: {content_type: :json, accept: :json }})
      data = {params: params, options: options}
      data = JWT.encode data, @params.fetch(:secret), 'HS512'
      token = @params.fetch(:token)
      @params.delete(:site)
      @params.delete(:secret)
      @params.delete(:token)
      params = {
        token: token,
        data: data
      }.to_json
      response = resource['/payments'].post params
    end
  end
end

