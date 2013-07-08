require 'httpclient'
require 'net/http/captured'

class HTTPClient
  alias :old_do_request :do_request
  def do_request(method, uri, query, body, header, &block)
    res = old_do_request(method, uri, query, body, header, &block)
    
    captured = Net::Captured::HTTPClient.new(res)
    
    Net::Captured::Responses.push(captured)
    res
  end
end

# Modifications of the base class to work with Net::HTTP
module Net
  module Captured
    class HTTPClient < Net::Captured::Base
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