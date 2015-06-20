require 'rest-client'
require 'jwt'
module PayApi

  class Authenticate
    attr_reader :params, :secret, :site

    # params = {
    #   key: <your api key>,
    #   site: <site of authentication>,
    #   secret: <your api key's secret>,
    #   password: <your api key's password>
    # }
    def initialize(params)
      @params = params
      @site = @params.fetch(:site)
      @secret = @params.fetch(:secret)
      RestClient.add_before_execution_proc do |req, params|
        req['alg'] = 'HS512'
      end
    end

    def call
      resource = RestClient::Resource.new(@site, {read_timeout: 10, open_timeout: 10,  headers: {content_type: :json, accept: :json }})
      api_key = params.fetch(:key)
      data = {apiKey: {'key': api_key, 'password': params.fetch(:password)}}
      token = JWT.encode data, @secret, 'HS512'
      params = {
        key: api_key,
        token: token
      }.to_json
      response = resource['/auth/login'].post params
    end
  end
end
