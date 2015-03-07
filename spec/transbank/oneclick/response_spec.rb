require 'spec_helper'

module Transbank
  module Oneclick
    describe Response  do

      describe 'init inscription' do

        describe 'with raise error' do
          let(:content) do
            Net::HTTPBadGateway.new("1.1", "502", "Bad Gateway").tap do |n|
              n.instance_variable_set(:@read, true)
            end
          end
          let(:response) { Response.new content, :initInscription}

          it { response.http_code.must_equal '502' }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.must_be_empty }
          it { response.errors_display.must_equal  'Bad Gateway' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Bad Gateway" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end

        describe 'with response valid' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8350"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-8349"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>dsJH15MYSVxtlBewmw7XtFm3/oM=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>Cq1ROc9mNYV1KKzMDEK6HypOfzF0o2z4TPjyaapxF14LUO5HkvxD4mPsZ/kjAkOdhr9CRIN6IZR5\nvDf9Q+IZueZylue40Yqy4k/a+g/yzGUOw2p2uGai9beKibBhhmJX2ORrAv8g0bHv+qoSYiZzG0mK\nwdgCTlYr361EWQrWqeQ4mQdhDgVhlBDt2Q9VyUepjWj4Cd30rw6bAKdRIAmGByglYTleG5Pinz4E\nLGKtjyDFAUZb8t3/Aya0cTA2NIypysKqUMw7Our9vF/ml7KNyaMF9AAPdcKzv0cAQ4Ebh8O9lUTP\n5mzcMM3fcWaR8vrPNproMzLOVLWDWoCgF4pijXFtWZWGDzqB1xzKembbdvEPAhtIgOw1z5Qyxhjq\nWrJWctIa2R4SyGbGZC3uOmfurDle/D74D5BlpyfeU84k7T+J5YObYYmIXAFPlxgmL5p5Zck1V+BB\n32O3LXMmi88PeXVO1eo8KKB/igqc0PAxYbMme4pHlidQgqUJpO2Dyd5F2+LOGKpRlMcjejzoutB2\nDX4eREUkTF/nAqcjeEm+08QR0cjsfo5iqZAKyXidzw+bIXcvFSwnTvK1xhzj3eNIkn/r1tf7uFGj\niVvXbdy+HOajwPFEUkcDddwmtLlSZ+pzTcn1FSsgxfjdzlLCp1t40IJaKOZJ0gBJbFG7lKdFuUs=</ds:SignatureValue><ds:KeyInfo Id="KI-F6DDC585AC5A582DD2142559657168312524"><wsse:SecurityTokenReference wsu:Id="STR-F6DDC585AC5A582DD2142559657168312525"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>CN=10,OU=ExperTI,O=ExperTI,L=Santiago,ST=Santiago,C=CL,1.2.840.113549.1.9.1=#16116a636572646140657870657274692e636c</ds:X509IssuerName><ds:X509SerialNumber>1401281826</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-8349"><ns2:initInscriptionResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return><token>e7667c5f871fa39e6c05549eeddd1ff07a520a769fa84cc6994465cdb06cbb4b</token><urlWebpay>https://webpay3g.orangepeople.cl/webpayserver/bp_inscription.cgi</urlWebpay></return></ns2:initInscriptionResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '200') }
          let(:response) { Response.new content, :initInscription}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '200' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.to_xml.must_equal '<token>e7667c5f871fa39e6c05549eeddd1ff07a520a769fa84cc6994465cdb06cbb4b</token><urlWebpay>https://webpay3g.orangepeople.cl/webpayserver/bp_inscription.cgi</urlWebpay>'}
          it { response.xml_error.must_be_empty }
          it { response.errors_display.must_be_empty }
          it { response.valid?.must_equal true }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: true, token: "e7667c5f871fa39e6c05549eeddd1ff07a520a769fa84cc6994465cdb06cbb4b", url_webpay: "https://webpay3g.orangepeople.cl/webpayserver/bp_inscription.cgi" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.token.must_equal 'e7667c5f871fa39e6c05549eeddd1ff07a520a769fa84cc6994465cdb06cbb4b'}
          it { response.url_webpay.must_equal 'https://webpay3g.orangepeople.cl/webpayserver/bp_inscription.cgi' }
          it { response.attributes.size.must_equal 2 }
        end

        describe 'with email not valid' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>Invalid email</faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :initInscription}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.to_xml.must_equal '<faultstring>Invalid email</faultstring>' }
          it { response.errors_display.must_equal 'Invalid email' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Invalid email" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end

        describe 'with username not valid' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>Username is required</faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :initInscription}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.to_xml.must_equal '<faultstring>Username is required</faultstring>' }
          it { response.errors_display.must_equal 'Username is required' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Username is required" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end

        describe 'with url not valid' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>URL is required</faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :initInscription}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.to_xml.must_equal '<faultstring>URL is required</faultstring>' }
          it { response.errors_display.must_equal 'URL is required' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "URL is required" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end
      end

      describe 'finish inscription' do
        describe 'with response valid' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8366"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-8365"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>fJP2u/9YdHinVin6lld9n4nEAvo=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>Nh8Pvf8QK20OKZ7Fa2lsPBClWvcCTTENIChbHui/sPJwUibVIT4V65kJ4oB2aMS3IhPpKdg7kLuv\nKoEZLIzTeERXC9DJgmrQdaSGr1E0Z/ML3cAapoxEDyZ2g0xpRdKND2mrLTXiXLYd1ZcLI4fod6v8\nxGt21rLABQpVIa/PUyhr4ZjqJ8aNxnds5k1FRkhECMJwLovMCn63jlcezc0Q0VtYULpm2wymThBx\nDxs0EuaqZ4uUJWRK/hhL0j9WR0rqTenN8Ok97Ko4HDvg/NL5PUH7xJKnByhKpqPOBqzLr07AZoCO\nTQc7a0dUN/Edw2DvDSlaM33eVoVzzONDnV40S7vIlaXi3U3WzebcDcXV+KF/TSwM7bSSVEDSGrdV\nvthCjv+XuoYnepqWoMTesDEo/bZ46l2gkVenn90APv7KSv0iem2dMcvUq7ftY//RTruHaUh0P3bi\nlosdu4zF5AxvY804t6fKWfoAwqZlhyt2s1HcSaOKX3Hck44NnSGwJBiGKwE1tEBs/jjb8VhkLkyW\nI9S09VaHlzwSW0PfAFdX4SrGq9fd0OlO35wQ2U31D5usBHvrDHfHBU0oLW/9li8rkroH8UgSnHbA\nyC7ktl+p9qABaioBCh3IF8JLcuXkElDCuCQmWYUaGv8mJ/4aYRhPh/rgdNRhcV5OuTWVQK43s94=</ds:SignatureValue><ds:KeyInfo Id="KI-F6DDC585AC5A582DD2142564457877312548"><wsse:SecurityTokenReference wsu:Id="STR-F6DDC585AC5A582DD2142564457877312549"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>CN=10,OU=ExperTI,O=ExperTI,L=Santiago,ST=Santiago,C=CL,1.2.840.113549.1.9.1=#16116a636572646140657870657274692e636c</ds:X509IssuerName><ds:X509SerialNumber>1401281826</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-8365"><ns2:finishInscriptionResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return><authCode>1213</authCode><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>0</responseCode><tbkUser>d2f27f36-b038-4937-8ea6-182b3de38cfd</tbkUser></return></ns2:finishInscriptionResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '200') }
          let(:response) { Response.new content, :finishInscription}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '200' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.to_xml.must_equal '<authCode>1213</authCode><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>0</responseCode><tbkUser>d2f27f36-b038-4937-8ea6-182b3de38cfd</tbkUser>'}
          it { response.xml_error.must_be_empty }
          it { response.errors_display.must_be_empty }
          it { response.valid?.must_equal true }
          it { response.response_code_display.must_equal 'aprobado' }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: true, auth_code: "1213", credit_card_type: "Visa", last4_card_digits: "6623", response_code: "0", tbk_user: "d2f27f36-b038-4937-8ea6-182b3de38cfd" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 5 }
          it { response.auth_code.must_equal '1213' }
          it { response.credit_card_type.must_equal 'Visa' }
          it { response.last4_card_digits.must_equal '6623' }
          it { response.response_code.must_equal '0' }
          it { response.tbk_user.must_equal 'd2f27f36-b038-4937-8ea6-182b3de38cfd' }
        end

        describe 'with token not valid' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>Can't finish user inscription</faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :finishInscription}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal []}
          it { response.xml_error.to_xml.must_equal '<faultstring>Can\'t finish user inscription</faultstring>'}
          it { response.errors_display.must_equal 'Can\'t finish user inscription' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Can\'t finish user inscription" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end

        describe 'with card unregistered' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8356"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-8355"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>jnlzX73k8Sgqj8z3h8X92UFF/OQ=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>U95EZ+m8b1Adg1wxpBuWkr1PqneEKbZ3vgaRioF2Fsnwa0thuf4ZvesbIKdhol2EoVxsa5aWAhf1\nGez3+z1kselbyQQHlnE6zo7O8QOE6t1z1dUDQZS13KmqHW8bW30xlRii809kmPfvszWnIkCjcCUg\nPUX3pK2pAmYuEIkJ1GXUtCob4h2a6m+YZkOTsK8hDyWKOY2LvosNIWnI209GCePZioA6e6FW4l83\nB2ZJzbXG7DxhQ45ePR98PwelF23U4GaaLLnHR+QdDOQG267+vm76cAETIbO+AMEzQOWNhFixSioJ\nCtg+hvszOrwwYlSsjEM2siY+yhZ92U1moh2peouvx59KB5VBKn+LTVv7xOZRnnhze+k4KP5I8ZV5\naJ8Xlkp8HqZbnEFlEukCODaQYscDWD9kGGZzEX33Ln1i4qI64c6VlGRHD6YAi9fgaNq+khAqUdcD\n+1HcNmDy2Jv0tP0ura6n8TqSHJ3agm9LaFr5b7K0u5WTsHWxk999HRkYz+ZhstnwNbTzrmE4/Mw/\nU10qdaonIGSkhWLqQigvD304a+SFqB4MBC/z3YsI0aNv4QrDnaZnJANyoJtiaq8lmcHD7ygZbT7L\n2us0rbudFbidqdj/yPS9TCkrD3XRxCMmhwjELzt3WJ0037SVNvdWKJ/QdgPgnDlTpuApDCLpK0U=</ds:SignatureValue><ds:KeyInfo Id="KI-F6DDC585AC5A582DD2142564333510612533"><wsse:SecurityTokenReference wsu:Id="STR-F6DDC585AC5A582DD2142564333510612534"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>CN=10,OU=ExperTI,O=ExperTI,L=Santiago,ST=Santiago,C=CL,1.2.840.113549.1.9.1=#16116a636572646140657870657274692e636c</ds:X509IssuerName><ds:X509SerialNumber>1401281826</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-8355"><ns2:finishInscriptionResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return><responseCode>-98</responseCode></return></ns2:finishInscriptionResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :finishInscription}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.to_xml.must_equal '<responseCode>-98</responseCode>'}
          it { response.xml_error.to_xml.must_be_empty }
          it { response.errors_display.must_equal 'Error' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_equal 'Error' }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, response_code: "-98", error: "Error" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 1 }
          it { response.response_code.must_equal '-98' }
        end
      end

      describe 'Authorize' do
        describe 'with response valid' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8376"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-8375"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>IC08S2+O4xGJRy9RPz1u51eTpOs=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>R9E7xvZEAWU4GPOksR6bws6dcEyLAeC1Rb0be511NGsSwXNbLdMsDMkEPT0CSGh4kT+sdG9JjGJJ\n8KnAWrqUYCBUwwniyxhHxcA1pfYrwE8lIdcd2dSHAWPeblrfuOWJqxl1gYJ1aVCMSrbzIyH+5WYl\nvQVUM5uJrMJaR88RydNNDAF4S8yp+4y1F3f5UhSP4KBOftDIPhixrQTEAcypZaTMQVf3+wqfQ1ME\nbsScaXmXitDZVkUSmSkLcif5IZex7b6tvDGeCtIxZtNZZRcPSifewztB/lD/0pp4A/ouVln7G67w\nd/PjXM4DPLKEN0AYv7ysKsOQ/kn9ress/mYSweSXJ3lTcfnD4zV1Fq4rBEU4aOu2PpOAU/Ye7E1M\nW14dIzJ8eRow9EFsb2tuPL9gixPSlAepV2zgSFNJ5vPlXJhsa3DhMph46sX7Ueqv+lZkAvz/EMSc\nGtw/N1m6Z64x+kVGyZuq3G52/NlmEx5WR/RmZmWYOF+O3pUWOjR82Wa1Gpb9YEbgHEMnNj+AcTZE\n2JemINg9FZNiwz+yMHxNAKUQsoRdB5DFPYi38YJqDyCwZAH/KPgHC+PgnrgeePUhAz5vvJo7a0qv\nU2CDdYWFx2OGdVsHRUbIOpdR7Wz3K4lQRxBP6AxA2fURV024Uw9hoihU1OtAUt9dQDnSgpURBpg=</ds:SignatureValue><ds:KeyInfo Id="KI-F6DDC585AC5A582DD2142566381917212563"><wsse:SecurityTokenReference wsu:Id="STR-F6DDC585AC5A582DD2142566381917212564"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>CN=10,OU=ExperTI,O=ExperTI,L=Santiago,ST=Santiago,C=CL,1.2.840.113549.1.9.1=#16116a636572646140657870657274692e636c</ds:X509IssuerName><ds:X509SerialNumber>1401281826</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-8375"><ns2:authorizeResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return><authorizationCode>1213</authorizationCode><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>0</responseCode><transactionId>71498</transactionId></return></ns2:authorizeResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '200') }
          let(:response) { Response.new content, :authorize}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '200' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.to_xml.must_equal '<authorizationCode>1213</authorizationCode><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>0</responseCode><transactionId>71498</transactionId>'}
          it { response.xml_error.must_be_empty }
          it { response.errors_display.must_be_empty }
          it { response.valid?.must_equal true }
          it { response.response_code_display.must_equal 'aprobado' }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: true, authorization_code: "1213", credit_card_type: "Visa", last4_card_digits: "6623", response_code: "0", transaction_id: "71498" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 5 }
          it { response.authorization_code.must_equal '1213' }
          it { response.credit_card_type.must_equal 'Visa' }
          it { response.last4_card_digits.must_equal '6623' }
          it { response.response_code.must_equal '0' }
          it { response.transaction_id.must_equal '71498' }
        end

        describe 'with amount not valid' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>Invalid amount</faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :authorize}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.to_xml.must_equal '<faultstring>Invalid amount</faultstring>' }
          it { response.errors_display.must_equal 'Invalid amount' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Invalid amount" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end

        describe 'with tbkUser blank' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>Tbk User is required</faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :authorize}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.to_xml.must_equal '<faultstring>Tbk User is required</faultstring>' }
          it { response.errors_display.must_equal 'Tbk User is required' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Tbk User is required" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end

        describe 'when tbkUser is not valid' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>Authorization failed</faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :authorize}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.to_xml.must_equal '<faultstring>Authorization failed</faultstring>' }
          it { response.errors_display.must_equal 'Authorization failed' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Authorization failed" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end

        describe 'with username blank' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Client</faultcode><faultstring>Unmarshalling Error: For input string: "" </faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :authorize}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.to_xml.must_equal '<faultstring>Unmarshalling Error: For input string: "" </faultstring>' }
          it { response.errors_display.must_equal 'Unmarshalling Error: For input string: "" ' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Unmarshalling Error: For input string: "" " >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end

        describe 'with maximum amount exceeded' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8418"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-8417"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>OGBAVz4h7um3+DFrHvBzahVmsDE=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>ZPg+X9p6U6cArwO93sZsU/c+FhKk0iiE6nLeS6gZZjsEvMDMpOjU6g5FJVUMVcXDJB2CkSBzOrEI\nD4awwE6vUWQ7jxlgchiME5HeQqok1wI9fMmNo3UfVt52/In6aCNrYeHlbYi+Zeod/05DUbTyznQS\nNax6v/WT2MUBs6usNe3aT3ryzY7WRuGdrP2lS3tmUQasfJBuZzCn7BqZULjWmi2+nlsmiVafIK0W\nOmNEV9XyUhsOKtrVEF7JGuJ9dJZP7cdYKVUOzFRnt/rdqHflghA4mr/WzEHVpVliA1MvgzJ0XvOw\nCRb4slH6EuSYNKmMZUoKDe3ShbcsBd0fz6RJwSoL5RN6mD+EA5KudbPimXD90WrqJCGbu1nIfXtr\n9DlmbEjobPApaRJ2e+m9of5KhoFNF76OXXumrrGgp8N/k/+jMyfX0abbLtzZfebvyWbeqO14XCzw\nyFO22RfVff9cpYS6vadUuu7dNe67QmbuZk8uTu+QNqSozO7wuDL336fNkMBafohKcSCzmZuXTqKp\nt4OJWYzINMKaypT06IWrGL83P3GBcqadKKo19IiZtiaQ9XJIhrZixYtHzDGV1cKKI7v+bBhZed+1\n2MR6e5ro6VdsMQCZ7C/BRT0sPd/0tinV4eJdNAquWT/a62c4HlCUAw/9iSbVzAhNV9QaCKGPX6Q=</ds:SignatureValue><ds:KeyInfo Id="KI-F6DDC585AC5A582DD2142573691238412626"><wsse:SecurityTokenReference wsu:Id="STR-F6DDC585AC5A582DD2142573691238412627"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>CN=10,OU=ExperTI,O=ExperTI,L=Santiago,ST=Santiago,C=CL,1.2.840.113549.1.9.1=#16116a636572646140657870657274692e636c</ds:X509IssuerName><ds:X509SerialNumber>1401281826</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-8417"><ns2:authorizeResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>-98</responseCode><transactionId>71686</transactionId></return></ns2:authorizeResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '200') }
          let(:response) { Response.new content, :authorize}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '200' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.to_xml.must_equal '<creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>-98</responseCode><transactionId>71686</transactionId>' }
          it { response.xml_error.to_xml.must_equal '' }
          it { response.errors_display.must_equal 'limites Oneclick, máximo monto de pago excedido' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_equal 'limites Oneclick, máximo monto de pago excedido' }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, credit_card_type: "Visa", last4_card_digits: "6623", response_code: "-98", transaction_id: "71686", error: "limites Oneclick, máximo monto de pago excedido" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 4 }
          it { response.credit_card_type.must_equal 'Visa' }
          it { response.last4_card_digits.must_equal '6623' }
          it { response.response_code.must_equal '-98' }
          it { response.transaction_id.must_equal '71686' }
        end

        describe 'with maximum payments exceeded' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8418"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-8417"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>OGBAVz4h7um3+DFrHvBzahVmsDE=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>ZPg+X9p6U6cArwO93sZsU/c+FhKk0iiE6nLeS6gZZjsEvMDMpOjU6g5FJVUMVcXDJB2CkSBzOrEI\nD4awwE6vUWQ7jxlgchiME5HeQqok1wI9fMmNo3UfVt52/In6aCNrYeHlbYi+Zeod/05DUbTyznQS\nNax6v/WT2MUBs6usNe3aT3ryzY7WRuGdrP2lS3tmUQasfJBuZzCn7BqZULjWmi2+nlsmiVafIK0W\nOmNEV9XyUhsOKtrVEF7JGuJ9dJZP7cdYKVUOzFRnt/rdqHflghA4mr/WzEHVpVliA1MvgzJ0XvOw\nCRb4slH6EuSYNKmMZUoKDe3ShbcsBd0fz6RJwSoL5RN6mD+EA5KudbPimXD90WrqJCGbu1nIfXtr\n9DlmbEjobPApaRJ2e+m9of5KhoFNF76OXXumrrGgp8N/k/+jMyfX0abbLtzZfebvyWbeqO14XCzw\nyFO22RfVff9cpYS6vadUuu7dNe67QmbuZk8uTu+QNqSozO7wuDL336fNkMBafohKcSCzmZuXTqKp\nt4OJWYzINMKaypT06IWrGL83P3GBcqadKKo19IiZtiaQ9XJIhrZixYtHzDGV1cKKI7v+bBhZed+1\n2MR6e5ro6VdsMQCZ7C/BRT0sPd/0tinV4eJdNAquWT/a62c4HlCUAw/9iSbVzAhNV9QaCKGPX6Q=</ds:SignatureValue><ds:KeyInfo Id="KI-F6DDC585AC5A582DD2142573691238412626"><wsse:SecurityTokenReference wsu:Id="STR-F6DDC585AC5A582DD2142573691238412627"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>CN=10,OU=ExperTI,O=ExperTI,L=Santiago,ST=Santiago,C=CL,1.2.840.113549.1.9.1=#16116a636572646140657870657274692e636c</ds:X509IssuerName><ds:X509SerialNumber>1401281826</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-8417"><ns2:authorizeResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>-97</responseCode><transactionId>71686</transactionId></return></ns2:authorizeResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '200') }
          let(:response) { Response.new content, :authorize}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '200' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.to_xml.must_equal '<creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>-97</responseCode><transactionId>71686</transactionId>' }
          it { response.xml_error.to_xml.must_equal '' }
          it { response.errors_display.must_equal 'limites Oneclick, máximo monto diario de pago excedido' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_equal 'limites Oneclick, máximo monto diario de pago excedido' }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, credit_card_type: "Visa", last4_card_digits: "6623", response_code: "-97", transaction_id: "71686", error: "limites Oneclick, máximo monto diario de pago excedido" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 4 }
          it { response.credit_card_type.must_equal 'Visa' }
          it { response.last4_card_digits.must_equal '6623' }
          it { response.response_code.must_equal '-97' }
          it { response.transaction_id.must_equal '71686' }
        end

        describe 'with maximum number of payments per day exceeded' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8418"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-8417"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>OGBAVz4h7um3+DFrHvBzahVmsDE=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>ZPg+X9p6U6cArwO93sZsU/c+FhKk0iiE6nLeS6gZZjsEvMDMpOjU6g5FJVUMVcXDJB2CkSBzOrEI\nD4awwE6vUWQ7jxlgchiME5HeQqok1wI9fMmNo3UfVt52/In6aCNrYeHlbYi+Zeod/05DUbTyznQS\nNax6v/WT2MUBs6usNe3aT3ryzY7WRuGdrP2lS3tmUQasfJBuZzCn7BqZULjWmi2+nlsmiVafIK0W\nOmNEV9XyUhsOKtrVEF7JGuJ9dJZP7cdYKVUOzFRnt/rdqHflghA4mr/WzEHVpVliA1MvgzJ0XvOw\nCRb4slH6EuSYNKmMZUoKDe3ShbcsBd0fz6RJwSoL5RN6mD+EA5KudbPimXD90WrqJCGbu1nIfXtr\n9DlmbEjobPApaRJ2e+m9of5KhoFNF76OXXumrrGgp8N/k/+jMyfX0abbLtzZfebvyWbeqO14XCzw\nyFO22RfVff9cpYS6vadUuu7dNe67QmbuZk8uTu+QNqSozO7wuDL336fNkMBafohKcSCzmZuXTqKp\nt4OJWYzINMKaypT06IWrGL83P3GBcqadKKo19IiZtiaQ9XJIhrZixYtHzDGV1cKKI7v+bBhZed+1\n2MR6e5ro6VdsMQCZ7C/BRT0sPd/0tinV4eJdNAquWT/a62c4HlCUAw/9iSbVzAhNV9QaCKGPX6Q=</ds:SignatureValue><ds:KeyInfo Id="KI-F6DDC585AC5A582DD2142573691238412626"><wsse:SecurityTokenReference wsu:Id="STR-F6DDC585AC5A582DD2142573691238412627"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>CN=10,OU=ExperTI,O=ExperTI,L=Santiago,ST=Santiago,C=CL,1.2.840.113549.1.9.1=#16116a636572646140657870657274692e636c</ds:X509IssuerName><ds:X509SerialNumber>1401281826</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-8417"><ns2:authorizeResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>-99</responseCode><transactionId>71686</transactionId></return></ns2:authorizeResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '200') }
          let(:response) { Response.new content, :authorize}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '200' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.to_xml.must_equal '<creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>-99</responseCode><transactionId>71686</transactionId>' }
          it { response.xml_error.to_xml.must_equal '' }
          it { response.errors_display.must_equal 'limites Oneclick, máxima cantidad de pagos diarios excedido' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_equal 'limites Oneclick, máxima cantidad de pagos diarios excedido' }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, credit_card_type: "Visa", last4_card_digits: "6623", response_code: "-99", transaction_id: "71686", error: "limites Oneclick, máxima cantidad de pagos diarios excedido" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 4 }
          it { response.credit_card_type.must_equal 'Visa' }
          it { response.last4_card_digits.must_equal '6623' }
          it { response.response_code.must_equal '-99' }
          it { response.transaction_id.must_equal '71686' }
        end
      end

      describe 'Reverse' do
        describe 'with response ok' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8432"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-8431"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>d5eiiC8lU9K+RwEa1fYFuCK2uOI=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>R075K3Tm1onQwi7Oxcw+Ha/31BQ0r4of5cNqOg6e/D3539aDw9m7LEFaMZoqtZ+G8aNlf/Nm1l12\ntG7bglfVO+/HrP6MxfC/VVLLFUO4EK7MCvAWa0qO4YaGXAE76rzN6ouO3W3e7mDXfeb3ChVSEobT\nX1LEOlB7ICW3YZXOYhnqyCxjoIkX8PdxDTEc4f3k9PjNaaXuVCzHg4X0KkPFOnRT1wXLLmgJoSOP\nnPjzVch2b+Z3QHYMIgd2d4intjz2XfwVj7SdjhCixpUa0foJR83NMykbSLFgxkJqYeYhhDLl8hvJ\nBd5vt2/Wx6R60Ctxgk3+NyKiuWXyYqMv5E4wzuXh+WSYQKccApE+6S4+E9V/zVO21F6cClhCEHxZ\nTH9ZikfBKUm5KSh9B7FqbH7DbnF4BhJDNEZXOvgBKvQNwt9hhsa07e/Kk9ZF+8vW5LpNTzf1sBJO\ndpiEZW+cKCOM8/xTscobqoIg3eRZOKdHe/gWoyyvc7PHHKQcc7bjRIUR53Pc0VYAXSB2MrV8GxL7\n13OxX4m/MrNX/M/6982n/QDW/X1EDHOrvKyknIjZ4IVkqpAm5QRZvlmmeWCL1zDiaIZkW4achjkZ\n1KVfhIwypN3MAgDa5a1JJxs00fKuDRTHs9BFrNxIm6UrR+isy+MD4j473hJUnvNT7xqZv0Ljvfg=</ds:SignatureValue><ds:KeyInfo Id="KI-F6DDC585AC5A582DD2142573852294212647"><wsse:SecurityTokenReference wsu:Id="STR-F6DDC585AC5A582DD2142573852294212648"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>CN=10,OU=ExperTI,O=ExperTI,L=Santiago,ST=Santiago,C=CL,1.2.840.113549.1.9.1=#16116a636572646140657870657274692e636c</ds:X509IssuerName><ds:X509SerialNumber>1401281826</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-8431"><ns2:codeReverseOneClickResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return><reverseCode>3619160862457231902</reverseCode><reversed>true</reversed></return></ns2:codeReverseOneClickResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '200') }
          let(:response) { Response.new content, :codeReverseOneClick}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '200' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.to_xml.must_equal '<reverseCode>3619160862457231902</reverseCode><reversed>true</reversed>'}
          it { response.xml_error.must_be_empty }
          it { response.errors_display.must_be_empty }
          it { response.valid?.must_equal true }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: true, reverse_code: "3619160862457231902", reversed: "true" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 2 }
          it { response.reverse_code.must_equal '3619160862457231902'}
          it { response.reversed.must_equal 'true' }
        end

        describe 'with buyorder blank' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Client</faultcode><faultstring>Unmarshalling Error: For input string: "" </faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :codeReverseOneClick}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.to_xml.must_equal '<faultstring>Unmarshalling Error: For input string: "" </faultstring>' }
          it { response.errors_display.must_equal 'Unmarshalling Error: For input string: "" ' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Unmarshalling Error: For input string: "" " >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end

        describe 'with buyorder blank' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8434"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-8433"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>/j2dFcNHzkq8gRjQkeA3DznM0h4=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>fJa28EFXMD+IS5FOVnPFFKEpJSqXAh8sG5A6prDMFg7RmffO3Seg0kGbnsCl1MaCw5lXoHa0DLHo\nNoX6BIgxNU/7jK+O9Z91VB7jKV4gO2fJKJN/dp30xxhctpFCmO+YYGuAwvsI0qwKUEWrVs6ZApnY\nuLAgyZO0xCp9DselwxkNanyIG7rekmpjYEs3nLFifyGH0w5DBNRPPgDtrBbYS6IIqqCmHuoBcel0\nCqsGFPJeC7Wtu3rZlZ2r9GWaVm6T2Dykg+Glnpr9sviHAwcPCkb2qpM5MiTnx3v39Mh7403j3U9k\nYJ9Lr26RV3zbPx5l+KBh4703sQ3kQzf1hwxP5IKvXsvkd9XLNBDthMJS1ghD/OPt+NcT8pgnCyV0\nJNOo0LpZt4ehHjVtfa68gIg+2T7sQ2+bpsBPgzAOSl6+n6VO2NPHEAGb/A9YOzQwizdCsrHrrPPW\nSJ39Pa9M2Ia7vj+K5xm1UnWpnNj3N5Ax6JrDkGchGsqp70TmSzjlsNFYuvHJd8akWK3KGolyISzW\nsqqJNo2oqb616s6hW4JbacxUS4zQ127jHikCqzqxI3zxgf1Qi5giF8FRIwPf5wbH9lDWke8+QOZI\nHdKW5EDx+mrN7Umf9brxnBGGNS3qhyl5P5HMRYPHBHc821iW0qkQ/E0KAHdLaEcb+Bj8Yt66lgg=</ds:SignatureValue><ds:KeyInfo Id="KI-F6DDC585AC5A582DD2142573918866412650"><wsse:SecurityTokenReference wsu:Id="STR-F6DDC585AC5A582DD2142573918866412651"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>CN=10,OU=ExperTI,O=ExperTI,L=Santiago,ST=Santiago,C=CL,1.2.840.113549.1.9.1=#16116a636572646140657870657274692e636c</ds:X509IssuerName><ds:X509SerialNumber>1401281826</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-8433"><ns2:codeReverseOneClickResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return><reversed>false</reversed></return></ns2:codeReverseOneClickResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :codeReverseOneClick}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.to_xml.must_equal '<reversed>false</reversed>' }
          it { response.xml_error.to_xml.must_equal '' }
          it { response.errors_display.must_equal 'imposible revertir la compra' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, reversed: "false", error: "imposible revertir la compra" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 1 }
          it { response.reversed.must_equal 'false' }
        end
      end

      describe 'Remove user' do
        describe 'with ok response' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-8436"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-8435"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>BtK1c6IQQt90kV7NJUMfdDFWdjU=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>VEH0ndx62nnFZYDmXfF9vnAksQbIn/epOBQhomEOfLOrTv0Zzi7q71uCQbUYUyF49z2MM56vzdI8\n2LVqSUY/ahsBgc/9L1+yK6TjuqxR/2nVRIil9QbyPjquCWYxnQbu4Pw442xf2savBgGQFyS+0NLJ\nqeKPaztSysUgJ2TKXFOeS7H3DgHIggz1har94US8WTFSgCOzfBeVhX+wNxZNgGUj4y/UO/4kuR1y\nAd/om6FX8EAre3EsawCOrVqLNSCG8kOW57ujcQQlgXKL0hI71C7HT62ysph5+hKmwAiyMAWaERr4\nsYxVI3tc3A/92NyWy6cg52xVSjJARLfLiqV/Dc1EoJqMFu6KLri3PdR9muIIUNp2heUVInaW6Xh6\n/7TnZSIXqwF0v0eMckTLU2amr9iRR4ipYHk/AmmInYMGtULXgNlHhRhk0UgvHqn0rsjVueDfHLtb\na+kNNExBqI1gazz0EV3NvhOBeFsu04YvyR2y4PTZokWLk3zfsmxTVbN9QIBGfKoK+E6ty4RlWOTH\nIIUzhDsP3yrjgC4UH2Zs7Kl/HYMXPkfZ0LoMNmJW2C5+BIYs8WDxXkpLkbtaEcfDpXfXTSsIyH3Y\nCQ2PguHy8NOcnETXlLieALLMVXvCmq3O0DoE6SWHq9URwqFnataMbHZhLOecDp3XmwMex7uNLac=</ds:SignatureValue><ds:KeyInfo Id="KI-F6DDC585AC5A582DD2142573978894412653"><wsse:SecurityTokenReference wsu:Id="STR-F6DDC585AC5A582DD2142573978894412654"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>CN=10,OU=ExperTI,O=ExperTI,L=Santiago,ST=Santiago,C=CL,1.2.840.113549.1.9.1=#16116a636572646140657870657274692e636c</ds:X509IssuerName><ds:X509SerialNumber>1401281826</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-8435"><ns2:removeUserResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return>true</return></ns2:removeUserResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '200') }
          let(:response) { Response.new content, :removeUser}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '200' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.to_xml.must_equal 'true'}
          it { response.xml_error.must_be_empty }
          it { response.errors_display.must_be_empty }
          it { response.valid?.must_equal true }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: true, text: "true" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 1 }
          it { response.text.must_equal 'true' }
        end

        describe 'with tbkUser blank ' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>Tbk User is required</faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :removeUser}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.to_xml.must_equal '<faultstring>Tbk User is required</faultstring>'}
          it { response.errors_display.must_equal 'Tbk User is required' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Tbk User is required" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end

        describe 'with username blank' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><soap:Fault><faultcode>soap:Server</faultcode><faultstring>Username is required</faultstring></soap:Fault></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '500') }
          let(:response) { Response.new content, :removeUser}

          it { response.body.must_equal body }
          it { response.http_code.must_equal '500' }
          it { response.doc.to_xml.must_equal Nokogiri::XML(body).to_xml }
          it { response.xml_result.must_equal [] }
          it { response.xml_error.to_xml.must_equal '<faultstring>Username is required</faultstring>'}
          it { response.errors_display.must_equal 'Username is required' }
          it { response.valid?.must_equal false }
          it { response.response_code_display.must_be_nil }
          it { response.inspect.must_equal '#<Transbank::Oneclick::Response valid: false, error: "Username is required" >' }
          it { response.exception?.must_equal false }
          it { response.exception.must_be_nil }
          it { response.attributes.size.must_equal 0 }
        end
      end

      def mock_content(body, code)
        mock do |m|
          stubs(:body).returns(body)
          stubs(:code).returns(code)
        end
      end
    end
  end
end
