require 'rack/test'
require 'rack/test/capture'

describe Rack::Test do
  include_examples "capturing HTTP responses"
  include Rack::Test::Methods

  # This spins up an in-process version of the app for testing with rack-test
  def app
    TestingApp.new
  end

  def perform_get(uri)
    get(uri)
  end
end