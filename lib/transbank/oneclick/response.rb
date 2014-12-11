module Transbank
  module Oneclick
    class Response
      attr_accessor :content, :action, :attributes, :errors, :exception

      RESPONSE_CODE = {
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
      }

      def initialize(content, action)
        self.content = content
        self.action = action
        self.attributes = xml_result.map{|e| [e.name.underscore.to_sym, e.text]}.to_h
        self.errors = []
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

      def response_code_display
        RESPONSE_CODE.fetch(response_code, response_code)
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
        def attributes_display
          attributes.map{|name, value| "#{name}: \"#{value}\""}.join ', '
        end

        def validate!
          if action =~ /finishInscription|Authorize/ and respond_to?(:response_code) and response_code != '0'
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
          end
        end
    end
  end
end