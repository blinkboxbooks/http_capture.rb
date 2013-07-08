require 'net/http'
require 'net/http/captured'

module Net
  class HTTPResponse
    class << self
      def new(httpv,code,msg)
        res = super

        captured = Net::Captured::NetHTTP.new(res)

        Net::Captured::Responses.push(captured)
        res
      end
    end
  end
end

module Net
  module Captured
    class NetHTTP < Net::Captured::Base
      def status
        @response.code.to_i
      end
    end
  end
end