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

  class ReadAdapter
    attr_reader :stored_body

    alias :old_write_to :<<
    # If a block is used to process the incoming body data, ensure we're keeping it for inspection later too
    def <<(str)
      (@stored_body ||= '') << str
      old_write_to(str)
    end
  end
end

module Net
  module Captured
    class NetHTTPResponse < Net::Captured::Response
      def status
        @real_response.code.to_i
      end

      def body
        return @real_response.body.stored_body if @real_response.body.respond_to? :stored_body
        @real_response.body
      end
    end
  end
end