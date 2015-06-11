require 'rest-client'
require 'jwt'
module PayApi

  class Authenticate
    attr_reader :attributes, :secret, :site

    # attributes = {
    #   key: <your api key>,
    #   site: <site of authentication>,
    #   secret: <your api key's secret>,
    #   password: <your api key's password>
    # }
    def initialize(attributes)
      @attributes = attributes
      @site = attributes.fetch(:site)
      @secret = attributes.fetch(:secret)
      RestClient.add_before_execution_proc do |req, params|
        req['alg'] = 'HS512'
      end
    end

    def call
      resource = RestClient::Resource.new(@site, { headers: {content_type: :json, accept: :json }})
      api_key = attributes.fetch(:key)
      data = {apiKey: {'key': api_key, 'password': attributes.fetch(:password)}}
      token = JWT.encode data, @secret, 'HS512'
      params = {
        key: api_key,
        token: token
      }.to_json
      response = resource['/auth/login'].post params
    end
  end
end
