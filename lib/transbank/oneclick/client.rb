module Transbank
  module Oneclick
    class Client
      attr_accessor :uri, :http
      HEADER = { 'Content-Type' => 'application/soap+xml; charset=utf-8' }

      def initialize(opt = {})
        opt = Transbank::Oneclick.configuration.http_options.merge(opt)
        self.uri = URI.parse Transbank::Oneclick.configuration.url
        self.http = Net::HTTP.new uri.host, uri.port

        # load options
        opt.each {|attr, value| http.__send__("#{attr}=", value)}
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      def post(xml_canonicalize)
        http.post(uri.path, xml_canonicalize, HEADER)
      end
    end
  end
end