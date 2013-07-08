($LOAD_PATH << File.expand_path("../lib", __FILE__)).uniq!
require "cucumber/rest/version"

Gem::Specification.new do |s|
  s.name = "cucumber-rest"
  s.version = Cucumber::Rest::VERSION
  s.summary = "Cucumber steps and support for testing RESTful services."
  s.description = "A set of Cucumber step definitions and support functions which encapsulate common RESTful functionality."
  s.author = "blinkbox books"
  s.email = "greg@blinkbox.com"
  s.homepage = "http://www.blinkboxbooks.com"
  s.license = "MIT"

  s.files = `git ls-files`.split($/)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.add_runtime_dependency "activesupport", ">= 3.2"
  s.add_runtime_dependency "cucumber", "~> 1.3"
  s.add_runtime_dependency "multi_json", "~> 1.7"
  s.add_runtime_dependency "rspec", "~> 2.13"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rack-test", "~> 0.6"
  s.add_development_dependency "mechanize", "~> 2.7"
  s.add_development_dependency "httpclient", "~> 2.3"
  s.add_development_dependency "rake", "~> 10.1"
  s.add_development_dependency "sinatra"

  s.add_development_dependency "yarjuf"
  s.add_development_dependency "cucumber_spinner"
end