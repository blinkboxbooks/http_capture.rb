require 'httpclient'
require 'net/http/captured'

class HTTPClient
  alias :old_do_request :do_request
  def do_request(method, uri, query, body, header, &block)
    real_response = old_do_request(method, uri, query, body, header, &block)
    Net::Captured::RESPONSES.push(Net::Captured::HTTPClientResponse.new(real_response))
    real_response
  end
end

# Modifications of the base class to work with HTTPClient
module Net
  module Captured
    class HTTPClientResponse < Net::Captured::Response
      # header access
      def [](key)
        @response.headers[key]
      end

      # Body access
      def body
        @response.content
      end
    end
  end
end