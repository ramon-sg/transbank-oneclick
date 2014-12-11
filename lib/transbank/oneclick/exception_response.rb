module Transbank
  module Oneclick
    class ExceptionResponse
      attr_accessor :exception, :action

      def initialize(exception, action)
        self.exception = exception
        self.action = action
      end

      def valid?
        false
      end

      def errors
        [exception.message]
      end

      def exception?
        true
      end

      def errors_display
        "#{exception.class}, #{exception.message}"
      end

      def inspect
        "#<#{self.class}:, valid: false, error: '#{errors_display}' >"
      end
    end
  end
end