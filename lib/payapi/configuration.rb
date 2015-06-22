module PayApi
  class Configuration
    extend Forwardable
    def_delegators :@hash, :to_hash, :[], :[]=, :==, :fetch, :delete, :has_key?, :to_s

    DEFAULTS = {
      site:         nil,
      key:          nil,
      password:     nil,
      secret:       nil,
      read_timeout: 60,
      open_timeout: 60
    }.freeze

    def initialize
      clear
    end

    def clear
      @hash = DEFAULTS.dup
    end

    def merge!(hash)
      hash = hash.dup
      @hash.merge!(hash)
    end
  end
end
