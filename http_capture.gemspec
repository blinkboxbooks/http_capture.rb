($LOAD_PATH << File.expand_path("../lib", __FILE__)).uniq!
require "http_capture/version"

Gem::Specification.new do |s|
  s.name = "http_capture"
  s.version = HttpCapture::VERSION
  s.summary = "Captures http responses from a number of libraries for testing."
  s.description = "Captures the Response objects from HTTParty, Mechanize, Net::HTTP, HTTPClient and Rack::Test and abstracts them for use in testing libraries."
  s.author = "blinkbox books"
  s.email = "jphastings@blinkbox.com"
  s.homepage = "http://blinkboxbooks.github.io/"
  s.license = "MIT"

  s.files = `git ls-files`.split($/)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.post_install_message = ":: Coded for blinkbox books :: Love books, love code? Get in touch ::"

  # These are the supported libraries.
  s.add_development_dependency "rack-test", "~> 0.6"
  s.add_development_dependency "mechanize", "~> 2.7"
  s.add_development_dependency "httpclient", "~> 2.3"
  s.add_development_dependency "httparty", "~> 0.11"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake", "~> 10.1"
  s.add_development_dependency "rspec", "~> 2.99"
  s.add_development_dependency "sinatra"
end