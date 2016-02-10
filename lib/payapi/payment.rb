require 'rest-client'
require 'jwt'
module PayApi

  class Payment
    attr_reader :params, :options, :data

    #params = {
    #  reference_number: <reference number of order for which this is a payment for>,
    #  cc_ccv2: <credit card ccv2>,
    #  cc_number: <credit card number>,
    #  cc_holder_name: <name of credit card owner>,
    #  cc_expires: <expiration date of credit card in mm/yy format>,
    #  success_callback: <callback url for a successful payment>,
    #  failure_callback: <callback url for a failed payment>,
    #  cancel_callback: <callback url for a cancelled payment>
    #  OR
    #  data: <jwt encoded data containing above parameters>
    #}
    #options = {
    #  ip_address: <ip address of client who entered credit card details>
    #}
    def initialize(params, options = {})
      @params = params
      @data = params[:data]
      @options = options
      RestClient.add_before_execution_proc do |req, params|
        req['alg'] = 'HS512'
      end
    end

    def payload
      if @data.nil?
        puts "********************************************"
        puts "PARAMS: #{params}"
        puts "********************************************"
        data = {params: params, options: options}
        data = JWT.encode data, CONFIG[:secret], 'HS512'
      else
        data = @data
      end
      JSON.parse(Authenticate.new.call).merge!({
        data: data
      }).to_json
    end

    def call
      resource = RestClient::Resource.new(
        CONFIG[:site],
        {
          read_timeout: CONFIG[:read_timeout],
          open_timeout: CONFIG[:open_timeout],
          headers: {content_type: :json, accept: :json }
        })
      puts "******************** payload"
      puts payload
      puts "******************** /payload"
      response = resource['/v1/api/authorized/payments'].post payload
      puts "******************** response"
      puts response
      puts "******************** /response"
    end
  end
end

