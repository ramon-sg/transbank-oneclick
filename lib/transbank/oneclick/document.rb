module Transbank
  module Oneclick
    class Document
      attr_accessor :action, :params, :doc, :cert, :private_key, :template
      SOAP_ENV = 'http://schemas.xmlsoap.org/soap/envelope/'
      NS1      = 'http://webservices.webpayserver.transbank.com/'
      WSSE     = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'
      WSU      = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'

      def initialize(action, params = {})
        self.cert = OpenSSL::X509::Certificate.new File.read(Transbank::Oneclick.configuration.cert_path)
        self.private_key = OpenSSL::PKey::RSA.new File.read(Transbank::Oneclick.configuration.key_path)
        self.action = action
        self.params = params
        self.doc = template.clone.doc
        sign!
      end

      def body_id
        OpenSSL::Digest::MD5.hexdigest(action.to_s + params.to_s + DateTime::now.to_s)
      end

      def body_node
        doc.at_xpath('//SOAP-ENV:Body')
      end

      def signed_node
        doc.at_xpath '//ds:SignedInfo', {'ds' => 'http://www.w3.org/2000/09/xmldsig#'}
      end

      def digest_value_node
        doc.at_xpath '//ds:DigestValue', {'ds' => 'http://www.w3.org/2000/09/xmldsig#'}
      end

      def signature_value_node
        doc.at_xpath '//ds:SignatureValue', {'ds' => 'http://www.w3.org/2000/09/xmldsig#'}
      end

      def body_canonicalize
        body_node.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, nil, nil)
      end

      def signed_node_canonicalize
        signed_node.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, nil, nil)
      end

      def canonicalize
        doc.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, nil, nil)
      end

      def digest_value
        Base64.encode64(OpenSSL::Digest::SHA1.digest(body_canonicalize)).gsub("\n", '')
      end

      def signature_value
        Base64.encode64(private_key.sign(OpenSSL::Digest::SHA1.new, signed_node_canonicalize)).gsub("\n", '')
      end

      def sign!
        digest_value_node.content = digest_value
        signature_value_node.content = signature_value
      end

      def template
        @template ||= Nokogiri::XML::Builder.new do |xml|
          xml['SOAP-ENV'].Envelope 'xmlns:SOAP-ENV' => SOAP_ENV, 'xmlns:ns1' => NS1 do
            xml.Header do
              xml['wsse'].Security 'xmlns:wsse' => WSSE, 'SOAP-ENV:mustUnderstand' => '1' do
                xml['ds'].Signature 'xmlns:ds' => 'http://www.w3.org/2000/09/xmldsig#' do
                  xml.SignedInfo do
                    xml.CanonicalizationMethod Algorithm: 'http://www.w3.org/2001/10/xml-exc-c14n#'
                    xml.SignatureMethod Algorithm: 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
                    xml.Reference URI: "##{body_id}" do
                      xml.Transforms do
                        xml.Transform Algorithm: 'http://www.w3.org/2001/10/xml-exc-c14n#'
                      end
                      xml.DigestMethod Algorithm: 'http://www.w3.org/2000/09/xmldsig#sha1'
                      xml.DigestValue ''
                    end
                  end
                  xml.SignatureValue ''
                  xml.KeyInfo do
                    xml['wsse'].SecurityTokenReference do
                      xml['ds'].X509Data do
                        xml.X509IssuerSerial do
                          xml.X509IssuerName cert.subject.to_s[1..-1].gsub('/', ',')
                          xml.X509SerialNumber cert.serial.to_s
                        end
                      end
                    end
                  end
                end
              end
            end
            xml.Body 'xmlns:wsu' => WSU, 'wsu:Id' => body_id  do
              xml['ns1'].send action do
                xml.arg0 do
                  params.each do |key, value|
                    xml.parent.namespace = xml.parent.namespace_definitions.first
                    xml.send key, value
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end