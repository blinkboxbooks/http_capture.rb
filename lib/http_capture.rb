require 'http_capture/version'

module HttpCapture
  RESPONSES = []

  class Response
    include Enumerable

    def initialize(real_response)
      @real_response = real_response
    end

    # The default header accessor
    def [](key)
      if @real_response.respond_to?(:[])
        @real_response[key]
      elsif @real_response.respond_to?(:headers)
        @real_response.headers[key]
      elsif @real_response.respond_to?(:header)
        @real_response.header[key]
      end
    end

    def each(&block)
      # some of the libraries return just header names in the each method; others return the header name and value
      # as an array. some downcase the header name but others leave them as they were. this adapts them to the most
      # useful and consistent which is an array of [name, value] with the name in lower case.
      action = Proc.new { |item| block.(item.is_a?(String) ? [item.downcase, self[item]] : item) }
      if @real_response.respond_to?(:each)
        @real_response.each &action
      elsif @real_response.respond_to?(:headers)
        @real_response.headers.each &action
      elsif @real_response.respond_to?(:header)
        @real_response.header.each &action
      end        
    end

    # The default status code accessor
    def status
      if @real_response.respond_to?(:code)
        @real_response.code.to_i
      else
        @real_response.status.to_i
      end
    end

    # The default body accessor
    def body
      @real_response.body
    end
  end
end