require 'yarjuf'
require 'webrick'
require 'rack'
require 'uri'
require 'logger'
require 'cucumber'

# This app allows us to make real HTTP responses from tests
class TestingApp
  # Call this with http://127.0.0.1:150685/?body=the_body&code=200&headers[Content-Type]=text/plain
  def call(env)
    params = {
      'body' => '',
      'headers' => {}
    }

    URI.decode(env['QUERY_STRING']).scan(/(?:^|&)([^=]+)=([^&]+)/).each do |details|
      if details.first =~ /^([^\[]+)\[([^\]]+)\]$/
        (params[$1] ||= {})[$2] = details.last
      else
        params[details.first] = details.last
      end
    end

    params['headers']['Content-Length'] ||= params['body'].length.to_s

    [(params['code'] || 200).to_i,params['headers'], [params['body']]]
  end
end

$server = ::WEBrick::HTTPServer.new({
  :BindAddress => '127.0.0.1',
  :Port => 0,
  :OutputBufferSize => 5,
  :Logger => WEBrick::Log.new("nul"), # equivalent to /dev/null but also works on Windows
  :AccessLog => []
})

$server.mount "/", Rack::Handler::WEBrick, TestingApp.new

$ready = false
$server.config[:StartCallback] = Proc.new{ $ready = true }

$server.config[:Logger].level = Logger::ERROR

Thread.new do
  $server.start
end

while not $ready
end

# TODO: Enclose this somwhere useful
def make_test_uri(code = 200, body = '', headers = {})
  u = URI.parse("http://127.0.0.1:#{$server.config[:Port]}/")

  u.query = "code=#{code.to_i.to_s}&body=#{URI.encode(body)}"
  headers.each_pair do |key, value|
      u.query << "&headers[#{URI.encode(key)}]=#{URI.encode(value)}"
  end

  u.to_s
end