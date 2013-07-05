($LOAD_PATH << File.expand_path("../lib", __FILE__)).uniq!
require "sandal/version"

Gem::Specification.new do |s|
  s.name = "cucumber-blinkbox-gemspec"
  s.version = Sandal::VERSION
  s.summary = "Cucumber steps and support for testing RESTful services."
  s.description = "A set of Cucumber step definitions and support functions which encapsulate common RESTful functionality."
  s.author = "blinkbox books"
  s.email = "tm-books-engineering@blinkbox.com"
  s.homepage = "https://git.mobcastdev.com/TEST/cucumber-blinkbox-rest"
  s.license = "MIT"

  s.files = `git ls-files`.split($/)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.add_runtime_dependency "cucumber", "~> 1.3"
  s.add_runtime_dependency "multi_json", "~> 1.7"
  s.add_runtime_dependency "rspec", "~> 2.13"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake", "~> 10.1"
end