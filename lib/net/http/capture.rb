require 'net/http'
require 'net/http/captured'

module Net
  class HTTP
    alias :old_request :request    
    def request(req, body = nil, &block)
      real_response = old_request(req, body, &block)
      Net::Captured::RESPONSES.push(Net::Captured::NetHTTPResponse.new(real_response))
      real_response
    end
  end  
end

module Net
  module Captured
    class NetHTTPResponse < Net::Captured::Response
      def status
        @response.code.to_i
      end
    end
  end
end