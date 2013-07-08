# Holds the class which tracks all captured HTTP events in any of the supported and switched on libraries.

module Net
  module Captured
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
end