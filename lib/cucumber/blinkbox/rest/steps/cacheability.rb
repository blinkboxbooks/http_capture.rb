require_relative "../cacheability"

Then(/^(?:the response|it) is publicly cacheable$/) do
  Cucumber::Blinkbox::Rest::Cacheability.ensure_response_is_publicly_cacheable
end

Then(/^(?:the response|it) is privately cacheable$/) do
  Cucumber::Blinkbox::Rest::Cacheability.ensure_response_is_privately_cacheable
end