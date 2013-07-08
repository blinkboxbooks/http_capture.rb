require_relative "../cacheability"
require_relative "../support/transforms"

Then(/^(?:the response|it) is publicly cacheable$/)
  Cucumber::Rest::Cacheability.ensure_response_is_publicly_cacheable
end

Then(/^(?:the response|it) is publicly cacheable for (#{CAPTURE_DURATION})$/) do |duration|
  Cucumber::Rest::Cacheability.ensure_response_is_publicly_cacheable # TODO: pass args!
end

Then(/^(?:the response|it) is publicly cacheable for between (#{CAPTURE_NUMBER}) and (#{CAPTURE_DURATION})$/) do |min_num, max_duration|
  Cucumber::Rest::Cacheability.ensure_response_is_publicly_cacheable # TODO: pass args!
end

Then(/^(?:the response|it) is privately cacheable$/) do
  Cucumber::Rest::Cacheability.ensure_response_is_privately_cacheable
end

Then(/^(?:the response|it) is not cacheable$/) do
  Cucumber::Rest::Cacheability.ensure_response_is_not_cacheable
end