module Transbank
  module Oneclick
    class Configuration
      attr_accessor :url
      attr_accessor :cert_path
      attr_accessor :key_path
      attr_accessor :rescue_exceptions
      attr_accessor :http_options

      def initialize
        self.rescue_exceptions = [Net::ReadTimeout, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
                                  Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError]
        self.http_options = {}
      end
    end
  end
end