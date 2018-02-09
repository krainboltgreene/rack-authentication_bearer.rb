module Rack
  class AuthenticationBearer
    class MissingBearerTokenError < StandardError
      STATUS = 422

      def initialize(message = nil)
        @message = message || "The Authentication header value was missing."
      end

      def status
        self.const_get("STATUS")
      end
    end
  end
end
