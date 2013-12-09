require 'httpclient'
require 'http_capture'

class HTTPClient
  alias :old_do_request :do_request
  def do_request(method, uri, query, body, header, &block)
    start_time = Time.now.to_f
    real_response = old_do_request(method, uri, query, body, header, &block)
    duration = Time.now.to_f - start_time

    captured_request = HttpCapture::HTTPClientRequest.new(method, uri, query)
    captured_response = HttpCapture::HTTPClientResponse.new(captured_request, real_response, duration)
    HttpCapture::RESPONSES.push(captured_response)

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
  class HTTPClientRequest < Request
    attr_reader :method, :path, :uri

    def initialize(method, uri, query)
      super(nil)
      @method = method.to_s.upcase
      @path = uri
      if query
        query = Rack::Utils.build_query(query) unless query.is_a?(String)
        @uri = URI.parse("#{uri}?#{query}")
      else
        @uri = uri.is_a?(URI) ? uri : URI.parse(uri)
      end
    end
  end

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