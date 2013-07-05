module Cucumber
  module Rest
    module Cacheability

      def ensure_response_is_publicly_cacheable(response = last_response)
        cache_control = parse_cache_control(response.header["Cache-Control"].first)
        cache_control.values_at("max-age").should_not include(nil), "Cache-Control must not include" # TODO: It would be better to have "public" explicitly...
        cache_control.values_at("private", "no-cache", "no-store", "must-revalidate", "proxy-revalidate").should include(nil)
        cache_control.values_at().should_not include(nil)
        cache_control["max-age"].should > 0

        date = Time.parse(response.header["Date"].first)
        expires = Time.parse(response.header["Expires"].first)
        expires.should > date
        (expires - date).should be_within(1).of cache_control["max-age"]

        last_modified = Time.parse(response.header["Last-Modified"].first)
        last_modified.should <= date

        response.header["Pragma"].count.should == 0
      end

      def ensure_response_is_privately_cacheable(response = last_response)
        cache_control = parse_cache_control(response.header["Cache-Control"].first)
        cache_control.values_at("private", "max-age").should_not include(nil)
        cache_control.values_at("public", "no-cache", "no-store", "must-revalidate", "proxy-revalidate").should include(nil)
        cache_control["max-age"].should > 0

        date = Time.parse(response.header["Date"].first)
        expires = Time.parse(response.header["Expires"].first)
        expires.should == date

        last_modified = Time.parse(response.header["Last-Modified"].first)
        last_modified.should <= date

        response.header["Pragma"].count.should == 0
      end

      private

      def parse_cache_control(header)
        header.split(",").each_with_object({}) do |entry, hash|
          key, value = entry.split("=", 2).map(&:strip)
          hash[key] = value =~ /^\d+$/ ? value.to_i : value
        end
      end

    end
  end
end