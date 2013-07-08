# HTTP Capture

Because it's beneficial to use a number of different HTTP libraries during our testing I've written a small script to capture the HTTP response information from each of the supported libraries so they can be examined after-the-fact. For example:

    require 'httpclient'
    # Include the relevant capture library
    require 'httpclient/capture'

    # Perform a request, as usual
    clnt = HTTPClient.new
    clnt.get_content("http://google.com") # => "<html>..."

    # Now you can retrieve all the captured responses:
    HttpCapture::RESPONSES.last.status # => 200
    HttpCapture::RESPONSES.last['Content-Length'] # => 12345
    HttpCapture::RESPONSES.last.body # => "<html>..."
    HttpCapture::RESPONSES.last.response # => <HTTPClient::Response>

The objects in the `HttpCapture::RESPONSES` array contain the exact objects, wrapped by helper functions which expose three methods: `code` for the status code, `[](key)` for accessing headers and `body` for reading the body of the document.

