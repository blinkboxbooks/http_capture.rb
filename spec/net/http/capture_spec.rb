require 'net/http'
require 'net/http/capture'
require 'uri'

describe Net::HTTP do
    include_examples "capturing HTTP responses"
    
    def perform_get(uri)
        uri = URI.parse(uri)

        Net::HTTP.get_response(uri)
    end
end