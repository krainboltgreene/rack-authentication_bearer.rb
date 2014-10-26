module Rack
  class AuthenticationBearer
    require_relative "authentication_bearer/version"
    EXPRESSION = /^Bearer\s+/
    RACK_KEY = "rack.authentication"
    AUTHENTICATION_KEY = "HTTP_AUTHENTICATION"
    AUTHORIZATION_KEY = "HTTP_AUTHORIZATION"

    attr_reader :process
    private :process

    def initialize(stack, &process)
      @stack = stack
      @process = process if block_given?
    end

    def call(previous_state)
      @state = previous_state

      if token && process
        state[RACK_KEY] = process.call(token)
      else
        state[RACK_KEY] = token
      end

      stack.call(state)
    end

    private def token
      if authentication.respond_to?(:split) && authentication.length > 0
        authentication.split(EXPRESSION).last
      end
    end

    private def authentication
      state[AUTHENTICATION_KEY] || state[AUTHORIZATION_KEY]
    end

    private def stack
      @stack
    end

    private def state
      @state
    end

    private def headers
      @headers
    end

    private def status
      @status
    end

    private def body
      @body
    end
  end
end
