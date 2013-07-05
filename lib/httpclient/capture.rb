require 'httpclient'
require 'net/http/captured'

class HTTPClient
  alias :old_do_request :do_request
  def do_request(method, uri, query, body, header, &block)
    res = old_do_request(method, uri, query, body, header, &block)
    
    # Modify the object for standardized access
    captured = res.dup
    def captured.[](key)
      self.headers[key]
    end

    Net::CapturedHTTP.push(captured)
    res
  end
end