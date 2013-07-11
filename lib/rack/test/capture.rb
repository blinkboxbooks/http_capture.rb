require 'rack/test'
require 'http_capture'

module Rack
  class MockSession
    # I *do not* like replicating functionality (this is a copy of the code from within rack/test's `Rack::MockSession`)
    # but for some reason this method pushes out an array, not the expected `@last_response` if I just call it with the
    # usual `alias` method. This works, let's leave it at that for now!
    def request(uri, env)
      env["HTTP_COOKIE"] ||= cookie_jar.for(uri)
      @last_request = Rack::Request.new(env)
      status, headers, body = @app.call(@last_request.env)

      @last_response = MockResponse.new(status, headers, body, env["rack.errors"].flush)

      HttpCapture::RESPONSES.push(HttpCapture::Response.new(@last_response))

      body.close if body.respond_to?(:close)

      cookie_jar.merge(last_response.headers["Set-Cookie"], uri)

      @after_request.each { |hook| hook.call }

      if @last_response.respond_to?(:finish)
        @last_response.finish
      else
        @last_response
      end
    end
  end
end