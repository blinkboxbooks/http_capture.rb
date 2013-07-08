# HTTP Capture

Allows access to the responses from a wide range of ruby HTTP libraries. This is super helpful for testing (especially with Cucumber).

Currently supports:

* [Net::HTTP](http://ruby-doc.org/stdlib-2.0/libdoc/net/http/rdoc/Net/HTTP.html) (and anything that uses it, specifically including:)
    * [Mechanize](http://mechanize.rubyforge.org/)
    * [HTTParty](http://httparty.rubyforge.org/rdoc/)
* [HTTPClient](http://rubydoc.info/gems/httpclient/2.1.5.2/HTTPClient)
* [Rack::Test](http://rdoc.info/github/brynary/rack-test/master/frames)

They can all be used by requiring `<library folder space>/capture` from your code, eg:

    require 'net/http/capture'
    require 'mechanize/capture'
    require 'httparty/capture'
    require 'httpclient/capture'
    require 'rack/test/capture'

## Install

Install the usual way:
    
    $ gem install http_capture

Or require it from within your gemspec and use `bundle`.

## Usage

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

