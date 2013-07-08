require 'httpclient'
require 'httpclient/capture'

describe HTTPClient do
    include_examples "capturing HTTP responses"
    
    def perform_get(uri)
        clnt = HTTPClient.new
        clnt.get_content(uri)
    end
end