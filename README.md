cucumber-blinkbox-rest
======================

Standard cucumber step definitions and helpers for testing RESTful APIs

## HTTP library abstraction

Because it's beneficial to use a number of different HTTP libraries during our testing I've written a small script to capture the HTTP response information from each of the supported libraries so they can be examined after-the-fact. For example:

    require 'httpclient'
    # Include the relevant capture library
    require 'httpclient/capture'

    # Perform a request, as usual
    clnt = HTTPClient.new
    clnt.get_content("http://google.com") # => "<html>..."

    # Now you can retrieve all the captured responses:
    Net::Captured::Responses.last.status # => 200
    Net::Captured::Responses.last['Content-Length'] # => 12345
    Net::Captured::Responses.last.body # => "<html>..."
    Net::Captured::Responses.last.response # => <HTTPClient::Response>

The objects in the Captured::Responses array contain the exact objects, wrapped by helper functions which expose three methods: `code` for the status code, `[](key)` for accessing headers and `body` for reading the body of the document.

