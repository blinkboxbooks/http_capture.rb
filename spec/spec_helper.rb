require 'yarjuf'
require 'webrick'
require 'sinatra/base'
require 'uri'
require 'logger'

# This app allows us to make real HTTP responses from tests
class TestingApp < Sinatra::Base
  # Call this with /?body=the_body&code=200&headers[Content-Type]=text/plain
  get '/' do
    halt params['code'].to_i, params['body']
  end
end

# Windows requires a different descriptor for "ignore the logs"
dev_null = case RUBY_PLATFORM
when /cygwin|mswin|mingw|bccwin|wince|emx/
  "nul"
else
  "/dev/null"
end

# Start the real server on any open port
$server = ::WEBrick::HTTPServer.new({
  :BindAddress => '127.0.0.1',
  :Port => 0,
  :OutputBufferSize => 5,
  :Logger => WEBrick::Log.new(dev_null),
  :AccessLog => []
})

# Mount the testing app for the tests to hit
$server.mount "/", Rack::Handler::WEBrick, TestingApp.new

# Ensure we don't start the tests until the server is ready
$ready = false
$server.config[:StartCallback] = Proc.new{ $ready = true }

$server.config[:Logger].level = Logger::ERROR

# Start the server in another thread
Thread.new do
  $server.start
end

# Wait for the server to be ready
while not $ready
end

# TODO: Enclose this somewhere useful
def make_test_uri(code = 200, body = '', headers = {})
  u = URI.parse("http://127.0.0.1:#{$server.config[:Port]}/")

  u.query = "code=#{code.to_i.to_s}&body=#{URI.encode(body)}"
  headers.each_pair do |key, value|
      u.query << "&headers[#{URI.encode(key)}]=#{URI.encode(value)}"
  end

  u.to_s
end