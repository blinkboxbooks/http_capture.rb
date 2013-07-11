require 'httpclient'
require 'http_capture'

class HTTPClient
  alias :old_do_request :do_request
  def do_request(method, uri, query, body, header, &block)
    real_response = old_do_request(method, uri, query, body, header, &block)
    HttpCapture::RESPONSES.push(HttpCapture::HTTPClientResponse.new(real_response))
    real_response
  end

  alias :old_get_content :get_content
  def get_content(uri, *args, &block)
    query, header = keyword_argument(args, :query, :header)
    success_content(follow_redirect(:get, uri, query, nil, header || {}, &block))
  end
end

# Modifications of the base class to work with HTTPClient
module HttpCapture
  class HTTPClientResponse < Response
    # def each
    #   @real_response.headers.each { |array| yield array.join(", ") }
    # end

    # Body access
    def body
      @real_response.content
    end
  end
end