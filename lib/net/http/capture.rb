require 'net/http'
require 'net/http/captured'

module Net
  class HTTPResponse
    class << self
      def new(httpv,code,msg)
        res = super
        Net::CapturedHTTP.push(res)
        res
      end
    end
  end
end