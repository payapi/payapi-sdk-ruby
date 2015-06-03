require 'rest-client'
module PayApi

  RestClient.add_before_execution_proc do |req, params|
    #content_type: :json,
    #  accept: :json
  end

  class Authenticate
    attr_reader :attributes, :site, :api_key, :password, :private_key

    def initialize(attributes)
      @attributes = attributes
    end

    def call
      @site = RestClient::Resource.new(attributes.fetch(:site))
      @api_key = attributes.fetch(:api_key)
      @password = attributes.fetch(:password)
      @private_key = attributes.fetch(:private_key)
      begin
        data = {
          api_key: api_key,
          password: password
        }.to_json
        response = site['/auth/login'].post data
      rescue => e
        e.response.code
      end
    end
  end
end
