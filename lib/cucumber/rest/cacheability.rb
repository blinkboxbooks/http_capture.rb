module Cucumber
  module Rest
    module Cacheability

      def ensure_response_is_publicly_cacheable(response = last_response)
        cache_control = parse_cache_control(response.header["Cache-Control"].first)
        require_cache_params(cache_control, "max-age")
        prohibit_cache_params(cache_control, "private", "no-cache", "no-store", "must-revalidate", "proxy-revalidate")
        cache_control["max-age"].should > 0, "The Cache-Control:max-age param must be greater than zero"

        date, expires, last_modified = extract_dates(response)
        (expires - date).should == cache_control["max-age"], "Date, Expires and Cache-Control:max-age are inconsistent"
        last_modified.should <= date, "Last-Modified should not be later than Date"

        response.header["Pragma"].count.should == 0
      end

      def ensure_response_is_privately_cacheable(response = last_response)
        cache_control = parse_cache_control(response.header["Cache-Control"].first)
        require_cache_params(cache_control, "private", "max-age")
        prohibit_cache_params(cache_control, "public", "no-cache", "no-store", "must-revalidate", "proxy-revalidate")
        cache_control["max-age"].should > 0, "The Cache-Control:max-age param must be greater than zero"
        
        date, expires, last_modified = extract_dates(response)
        expires.should <= date, "Expires should not be later than Date"
        last_modified.should <= date, "Last-Modified should not be later than Date"

        response.header["Pragma"].count.should == 0
      end

      def ensure_response_is_not_cacheable(response = last_response)
        cache_control = parse_cache_control(response.header["Cache-Control"].first)
        require_cache_params(cache_control, "no-store")
        prohibit_cache_params(cache_control, "public", "private", "max-age", "no-cache", "must-revalidate", "proxy-revalidate")
        
        date, expires, last_modified = extract_dates(response)
        expires.should <= date, "Expires should not be later than Date"
        last_modified.should <= date, "Last-Modified should not be later than Date"

        response.header["Pragma"].should include("no-cache")
      end

      private

      def parse_cache_control(header)
        header.split(",").each_with_object({}) do |entry, hash|
          key, value = entry.split("=", 2).map(&:strip)
          hash[key] = value =~ /^\d+$/ ? value.to_i : value
        end
      end

      def require_cache_params(cache_control, *keys)
        keys.each { |key| raise "The Cache-Control header must include #{key}" if cache_control[key].nil? }
      end

      def prohibit_cache_params(cache_control, *keys)
        keys.each { |key| raise "The Cache-Control header must not include #{key}" unless cache_control[key].nil? }
      end

      def extract_dates(response)
        date = date_from_header("Date")
        expires = date_from_header("Expires")
        last_modified = date_from_header("Last-Modified")
        return date, expires, last_modified
      end

      def date_from_header(response, name)
        Time.parse(response.header[name].first)
      end

    end
  end
end