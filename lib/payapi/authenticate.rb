require 'rest-client'
require 'jwt'
module PayApi

  class Authenticate
    attr_reader :attributes, :private_key, :site

    # attributes = {
    #   key: <your api key>,
    #   site: <site of authentication>,
    #   private_key: <your private key>,
    #   password: <your api key's password>
    # }
    def initialize(attributes)
      @attributes = attributes
      @site = attributes.fetch(:site)
      @private_key = attributes.fetch(:private_key)
      RestClient.add_before_execution_proc do |req, params|
        req['alg'] = 'HS512'
      end
    end

    def call
      resource = RestClient::Resource.new(@site, { headers: {content_type: :json, accept: :json }})
      api_key = attributes.fetch(:key)
      data = {user: {'key': api_key, 'password': attributes.fetch(:password)}}
      token = JWT.encode data, @private_key, 'HS512'
      params = {
        key: api_key,
        token: token
      }.to_json
      response = resource['/auth/login'].post params
    end
  end
end
