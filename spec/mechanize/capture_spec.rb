require 'mechanize'
require 'mechanize/capture'

describe Mechanize do
    include_examples "capturing HTTP responses"
    
    def perform_get(uri)
        a = Mechanize.new
        a.get(uri)
    end
end