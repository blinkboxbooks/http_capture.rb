require 'httpclient'
require 'net/http/captured'

class HTTPClient
  alias :old_do_request :do_request
  def do_request(method, uri, query, body, header, &block)
    res = old_do_request(method, uri, query, body, header, &block)
    
    # Modify the object for standardized access
    def res.[](key)
      self.headers[key]
    end

    def res.body
      self.content
    end

    Net::CapturedHTTP.push(res)
    res
  end
end