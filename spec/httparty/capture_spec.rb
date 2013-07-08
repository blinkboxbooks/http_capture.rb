require 'httparty'
require 'httparty/capture'

describe HTTParty do
    include_examples "capturing HTTP responses"
    
    def perform_get(uri)
        HTTParty.get(uri)
    end
end