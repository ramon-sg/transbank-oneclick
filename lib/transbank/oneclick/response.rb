module Transbank
  module Oneclick
    class Response
      attr_accessor :content, :action, :attributes, :errors, :exception

      RESPONSE_CODE = {
        authorize: {
          '0'   => 'aprobado',
          '-1'  => 'rechazo',
          '-2'  => 'rechazo',
          '-3'  => 'rechazo',
          '-4'  => 'rechazo',
          '-5'  => 'rechazo',
          '-6'  => 'rechazo',
          '-7'  => 'rechazo',
          '-8'  => 'rechazo',
          '-97' => 'limites Oneclick, máximo monto diario de pago excedido',
          '-98' => 'limites Oneclick, máximo monto de pago excedido',
          '-99' => 'limites Oneclick, máxima cantidad de pagos diarios excedido'
        },
        default: {
          '0'   => 'aprobado',
          '-98' => 'Error'
        }
      }

      def initialize(content, action)
        self.content = content
        self.action = action
        self.attributes = Hash[*xml_result.map{|e| [e.name.underscore.to_sym, e.text]}.flatten]
        self.errors = []

        logger = Transbank::Oneclick.configuration.logger
        if logger
          logger.info "Transbank #{action} response"
          logger.info doc.to_s
        end

        validate!
      end

      def body
        content.body
      end

      def http_code
        content.code
      end

      def doc
        @doc ||= Nokogiri::XML body
      end

      def xml_result
        doc.at_xpath("//return") && doc.at_xpath("//return").children || []
      end

      def xml_error
        doc.xpath("//faultstring")
      end

      def errors_display
        errors.join ', '
      end

      def valid?
        errors.empty?
      end

      def signed_node
        doc.at_xpath '//ds:SignedInfo', {'ds' => 'http://www.w3.org/2000/09/xmldsig#'}
      end

      def signature_node
        doc.at_xpath('//ds:SignatureValue', {'ds' => 'http://www.w3.org/2000/09/xmldsig#'})
      end

      def signature_decode
        Base64.decode64(signature_node.content)
      end

      def response_code_display
        if respond_to?(:response_code)
          # key = RESPONSE_CODE.keys.include?(action) ? action : :default
          # RESPONSE_CODE[key].fetch(response_code, response_code)
          RESPONSE_CODE[action] && RESPONSE_CODE[action][response_code] || RESPONSE_CODE[:default][response_code] || response_code
        end
      end

      def inspect
        result = ["valid: #{valid?}"]
        result << attributes_display if attributes.any?
        result << "error: \"#{errors_display}\"" if errors.any?
        "#<#{self.class} #{result.join(', ')} >"
      end

      def exception?
        false
      end

      def exception
        nil
      end

      def method_missing(method_name, *args, &block)
        attributes[method_name.to_sym] || super
      end

      def respond_to_missing?(method_name, include_private = false)
        attributes.keys.include?(method_name.to_sym) || super
      end

      private

      def verify
        return if signature_node.nil?

        signed_node.add_namespace 'soap', 'http://schemas.xmlsoap.org/soap/envelope/'
        signed_node_canonicalize = signed_node.canonicalize Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, ["soap"], nil

        pub_key.verify OpenSSL::Digest::SHA1.new, signature_decode, signed_node_canonicalize
      end

      def server_cert
        @server_cert ||= OpenSSL::X509::Certificate.new File.read(Transbank::Oneclick.configuration.server_cert_path)
      end

      def pub_key
        server_cert.public_key
      end

      def attributes_display
        attributes.map{|name, value| "#{name}: \"#{value}\""}.join ', '
      end

      def validate!
        if action =~ /finishInscription|Authorize|/ and respond_to?(:response_code) and response_code != '0'
          self.errors << response_code_display
        end

        if action =~ /removeUser/ and respond_to?(:text) and text != 'true'
          self.errors << 'imposible eliminar la inscripción'
        end

        if action =~ /codeReverseOneClick/ and respond_to?(:reversed) and reversed != 'true'
          self.errors << 'imposible revertir la compra'
        end

        if content.class != Net::HTTPOK
          self.errors += xml_error.map(&:text)
          self.errors << content.message if content.respond_to?(:message)
        end

        if (self.errors.blank? || signature_node.present?) && !verify
          raise Exceptions::InvalidSignature.new("Invalid signature")
        end
      end
    end
  end
end