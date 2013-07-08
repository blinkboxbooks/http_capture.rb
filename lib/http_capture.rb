require 'http_capture/version'

module HttpCapture
  RESPONSES = []

  class Response
    def initialize(real_response)
      @real_response = real_response
    end

    # The default header accessor
    def [](key)
      @real_response[key]
    end

    # The default status code accessor
    def status
      @real_response.status
    end

    # The default body accessor
    def body
      @real_response.body
    end
  end
end