module Transbank
  module Oneclick
    class Request
      attr_accessor :xml, :client, :action, :rescue_exceptions

      def initialize(action, params = {}, opt = {})
        opt = {
          rescue_exceptions: Transbank::Oneclick.configuration.rescue_exceptions,
          http_options: {}
        }.merge(opt)

        self.action = action
        self.rescue_exceptions = opt[:rescue_exceptions]
        self.xml = Document.new(action, params)
        self.client = Client.new opt.delete(:http_options)
      end

      def response
        @Response ||= begin
          Response.new client.post(xml.canonicalize), action
        rescue match_class(rescue_exceptions) => error
          ExceptionResponse.new error, action
        end
      end

      private
        def match_class(exceptions)
          m = Module.new
          (class << m; self; end).instance_eval do
            define_method(:===) do |error|
              (exceptions || []).include? error.class
            end
          end
          m
        end
    end
  end
end