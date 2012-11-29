module Backplane
  class Response
    attr_reader(:code, :message, :body)

    def initialize(code, message, body)
      @code = code
      @message = message
      @body = body
    end

    def hasError
      return code.to_i != 200
    end
  end
end
