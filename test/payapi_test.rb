require 'test_helper'
require 'payapi/authenticate'
require 'jwt'

class TestPayapi < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Payapi::VERSION
  end
end
