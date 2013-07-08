require "active_support/core_ext/numeric/time"

unless defined?(CAPTURE_DURATION)
  CAPTURE_DURATION = Transform(/^(?:(a)|#{CAPTURE_NUMBER}) (week|day|hour|minute|second)s?)$/) do |num, unit|
    num = 1 if num == "a"
    num.send(unit.to_sym)
  end
end

unless defined?(CAPTURE_NUMBER)
  CAPTURE_NUMBER = Transform(/^\d+(?:\.\d+)?$/) do |num|
    num =~ /\./ ? num.to_f : num.to_i
  end
end