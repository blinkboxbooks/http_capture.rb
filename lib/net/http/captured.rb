# Holds the class which tracks all captured HTTP events in any of the supported and switched on libraries.

module Net
    module Captured
      Responses = []

      class Base
        attr_reader :response

        def initialize(response)
          @response = response
        end

        # The default header accessor
        def [](key)
          @response[key]
        end

        # The default status code accessor
        def status
          @response.status
        end

        # The default body accessor
        def body
          @response.body
        end
      end
    end
end