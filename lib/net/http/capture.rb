require 'net/http'
require 'http_capture'

module Net
  class HTTP
    alias :old_request :request    
    def request(req, body = nil, &block)
      real_response = old_request(req, body, &block)

      HttpCapture::RESPONSES.push(HttpCapture::NetHTTPResponse.new(real_response))
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

module HttpCapture
  class NetHTTPResponse < HttpCapture::Response
    def body
      return @real_response.body.stored_body if @real_response.body.respond_to? :stored_body
      @real_response.body
    end
  end
end