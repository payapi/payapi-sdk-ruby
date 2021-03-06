require 'rest-client'
require 'jwt'
module PayApi

  class Authenticate
    def initialize
      RestClient.add_before_execution_proc do |req, params|
        req['alg'] = 'HS512'
      end
    end

    def payload
      api_key = CONFIG[:key]
      password = CONFIG[:password]
      data = {apiKey: {'key': api_key, 'password': password}}
      token = JWT.encode data, CONFIG[:secret], 'HS512'
      {
        key: api_key,
        token: token
      }.to_json
    end

    def call(given_payload = nil)
      if @token.nil? || @token[:expires] >= Time.now
        resource = RestClient::Resource.new(
          CONFIG[:site],
          {
            read_timeout: CONFIG[:read_timeout],
            open_timeout: CONFIG[:open_timeout],
            headers: {content_type: :json, accept: :json }
          }
        )
        @token = resource['/v1/api/auth/login'].post given_payload || payload
      end
      @token
    end
  end
end
