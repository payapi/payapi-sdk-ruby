require 'payapi/version'
require 'payapi/configuration'
require 'payapi/authenticate'
require 'payapi/payment'

module PayApi
  extend self

  CONFIG = Configuration.new

  def configure(opts={})
    CONFIG.merge!(opts)
    @configured = true
  end

  def token
    @token = Authenticate.new.call
  end
end
