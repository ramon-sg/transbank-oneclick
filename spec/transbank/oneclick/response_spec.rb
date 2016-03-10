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
          let(:body) { "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" soap:mustUnderstand=\"1\"><ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"SIG-8350\"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"soap\"></ec:InclusiveNamespaces></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></ds:SignatureMethod><ds:Reference URI=\"#id-8349\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"\"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></ds:DigestMethod><ds:DigestValue>dsJH15MYSVxtlBewmw7XtFm3/oM=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>kTZH5cri06sQcJ6diYQLdzYnSGqny28GbEo1S47+27BhcWNi3bgca1t11v5Xd5xl6CNqHH6ty3xyq3fPt7ahb7zzot2z0CIJ6cvsxJ9171spZxvwrU0ywBPeo9Wh2Qpf57NYS2EUEOT2VmLEECt8mKofPq2lTEKsIxFsKFIw5mN0CL0MkBpaMTJMWEzToTY9ANWEKThiD9jp2qZs3gcqX3JzDVhmhdHtliVvKv+PXkZRu0eHqF78BW8qcE6TNPuhIcd+dOkRc2ApLhjXRg5RlPrRt0gEgAfo6IXCQ1hOnhJfsY3ygyPypHV94uNFsRlgO7DmPcoCqOAd0uprnFBFwQ==</ds:SignatureValue><ds:KeyInfo Id=\"KI-F6DDC585AC5A582DD2142559657168312524\"><wsse:SecurityTokenReference xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"STR-F6DDC585AC5A582DD2142559657168312525\"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"id-8349\"><ns2:initInscriptionResponse xmlns:ns2=\"http://webservices.webpayserver.transbank.com/\"><return><token>e7667c5f871fa39e6c05549eeddd1ff07a520a769fa84cc6994465cdb06cbb4b</token><urlWebpay>https://webpay3g.orangepeople.cl/webpayserver/bp_inscription.cgi</urlWebpay></return></ns2:initInscriptionResponse></soap:Body></soap:Envelope>" }
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

        describe 'with valid signature' do
          let(:body) { %q{<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" soap:mustUnderstand="1"><ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#" Id="SIG-4250"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList="soap"/></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/><ds:Reference URI="#id-4249"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"><ec:InclusiveNamespaces xmlns:ec="http://www.w3.org/2001/10/xml-exc-c14n#" PrefixList=""/></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/><ds:DigestValue>j754dDxPx/xkw/3ZgiQ8mmPesrI=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>cPQGBl2IVWR+e4zGnzo6p0G9mbdfQs/WRMWMFMCD6bXFjCxfDf51GdJsUKYUoe+x6zaecLzsSdjLQBSjnBwdvpyZnN4ggnmi3SXsn2yjHY7rLca1yo+Y/Rdet/suDExd9jOoNpoiSHYOeD+i9vei5+EX5Juip/WSMmIXX/dDBi72iCxTKlj1oRH1Y0Papweq96fM1jRnMxEHX+otb5Road6b7exhMFPGM5mtpo2pYesMzkEuOxznXpjfdRugzTrYkC/o2/R603XPCE9Q9L3HN9ULjbORxqIkPEQpjuyK+H/GRLsvCeAsDPCkhTXicPJG/e92gy7Csc21ygEWuLL97NOT/VALID==</ds:SignatureValue><ds:KeyInfo Id="KI-3EEEE6B294556BE95914575557309416374"><wsse:SecurityTokenReference wsu:Id="STR-3EEEE6B294556BE95914575557309416375"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="id-4249"><ns2:initInscriptionResponse xmlns:ns2="http://webservices.webpayserver.transbank.com/"><return><token>a65f2cf8077b1d45c36e698fe6bf8111ba43562565dac63f9017f4a3f154b1c8</token><urlWebpay>https://tbk.cl/webpayserver/bp_inscription.cgi</urlWebpay></return></ns2:initInscriptionResponse></soap:Body></soap:Envelope>} }
          let(:content) { mock_content(body, '200') }

          it { proc { Response.new content, :initInscription }.must_raise(Transbank::Oneclick::Exceptions::InvalidSignature) }
        end
      end

      describe 'finish inscription' do
        describe 'with response valid' do
          let(:body) {  "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" soap:mustUnderstand=\"1\"><ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"SIG-8366\"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"soap\"></ec:InclusiveNamespaces></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></ds:SignatureMethod><ds:Reference URI=\"#id-8365\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"\"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></ds:DigestMethod><ds:DigestValue>fJP2u/9YdHinVin6lld9n4nEAvo=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>ll/FkhjU2HdcHwHUbkUAhb20cnpMiRlt5d96DZw2AADeo/x4/NPAwsImU/o3ZrYMVXAyhRLUI/VweuAEXgd5AuQ37xxL7QFaGcWO7roX2kom6FhhHD4ORgWigfgrp7U90diqnUVmBu/7ewlUAEt+8RK+V5dt+nDuaeyyk7COLj6jwR0SXQqcDd69dYLFkaniP3foQJo0zC2JNzepZHCRCvD2I4Fl1shViTghs72GDhsZR8dw6hsCvzLNuAfJx9gd6NSkG43as6Yfse0sDJvGggCRUfaGJdCLSAqk3JcETb+RMPIm82ECjLYmLuTSCEoIm+aQeIbAn78ZMFYIJcGVCw==</ds:SignatureValue><ds:KeyInfo Id=\"KI-F6DDC585AC5A582DD2142564457877312548\"><wsse:SecurityTokenReference xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"STR-F6DDC585AC5A582DD2142564457877312549\"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"id-8365\"><ns2:finishInscriptionResponse xmlns:ns2=\"http://webservices.webpayserver.transbank.com/\"><return><authCode>1213</authCode><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>0</responseCode><tbkUser>d2f27f36-b038-4937-8ea6-182b3de38cfd</tbkUser></return></ns2:finishInscriptionResponse></soap:Body></soap:Envelope>" }
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
          let(:body) { "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" soap:mustUnderstand=\"1\"><ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"SIG-8356\"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"soap\"></ec:InclusiveNamespaces></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></ds:SignatureMethod><ds:Reference URI=\"#id-8355\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"\"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></ds:DigestMethod><ds:DigestValue>jnlzX73k8Sgqj8z3h8X92UFF/OQ=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>J9gzXDSXHWe0nKwha3rY9+aqOTIvhxq5xyjfdrwjKQPjsggI6dXIzgzKLruKp5kGQ0UeIBixjryd7twkGAiq7+T+BGy120ELFapmkNcasyDRuWo3U6PxZidhtMYdFT1ewpsyJaNqb0ck7TBIH5Vk503vnV0QUUP2tK+CDA94fDS5uvJhv2SDNccYEs89E3UVfp1DMH0OJXakdMvD0aWHK0/ChH9eAniGBSakmJf0cCPBbnN1EPGVAgUMBhatCFrGq4oT251DUY+JG9hVw22c+JJnN7WsetFh2IbthQR6bT4kVOy01aTHoHsyt7/LAPoSK738Pwme4er9wrYKJ8gWew==</ds:SignatureValue><ds:KeyInfo Id=\"KI-F6DDC585AC5A582DD2142564333510612533\"><wsse:SecurityTokenReference xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"STR-F6DDC585AC5A582DD2142564333510612534\"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"id-8355\"><ns2:finishInscriptionResponse xmlns:ns2=\"http://webservices.webpayserver.transbank.com/\"><return><responseCode>-98</responseCode></return></ns2:finishInscriptionResponse></soap:Body></soap:Envelope>" }
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
          let(:body) { "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" soap:mustUnderstand=\"1\"><ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"SIG-8376\"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"soap\"></ec:InclusiveNamespaces></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></ds:SignatureMethod><ds:Reference URI=\"#id-8375\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"\"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></ds:DigestMethod><ds:DigestValue>IC08S2+O4xGJRy9RPz1u51eTpOs=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>j6c+/lI6OXehruaLwCqENZeNkAP7ynaZyJjEV3mty0VhlCzhjB8x6s9m372Az6Cbiv6jnNtK8EQr8VSiSZWTGDHnd+9H4O5t7fxe83m5HgcraJjt12+CFlVllBWbIQldFa5ZZjEqQrmGDd2a5ssO3qrN0SiCuLSlhSP1cPZclciD7sEEyRtcnEEbv8JcW/CMDcsila9UYUhtogOzclXz/eZ+wc6pjBkbuOgifkmeofhFRwK8M9FelavzJHwQTIOGPoUNWvCrTa6/CBDtgPXqMbTMokE9IUCbrNtd608FxUFsED1Q4zsW51FNnP5Ch95R5e10VMSFWeBiqwx0OVvopw==</ds:SignatureValue><ds:KeyInfo Id=\"KI-F6DDC585AC5A582DD2142566381917212563\"><wsse:SecurityTokenReference xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"STR-F6DDC585AC5A582DD2142566381917212564\"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"id-8375\"><ns2:authorizeResponse xmlns:ns2=\"http://webservices.webpayserver.transbank.com/\"><return><authorizationCode>1213</authorizationCode><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>0</responseCode><transactionId>71498</transactionId></return></ns2:authorizeResponse></soap:Body></soap:Envelope>" }
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
          let(:body) { "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" soap:mustUnderstand=\"1\"><ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"SIG-8418\"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"soap\"></ec:InclusiveNamespaces></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></ds:SignatureMethod><ds:Reference URI=\"#id-8417\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"\"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></ds:DigestMethod><ds:DigestValue>OGBAVz4h7um3+DFrHvBzahVmsDE=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>Omu6ivCCcimlQGb6PQXVlKHaLO3OD/PWT3ojxn0I3X5W0f3z5Q6XXnjkXJRLSp/SOxkFmod+jj2SZ8EawdT4jNmBq44VaA8wXHmsp8cNjRjAlU4l88MOXLTFk3lIxnDN4N6O9FV1NoPiZlLDAD8dLL4Lh9u9dxOEm0yin/nrETg8V/U3drDicae0qRBWTyHXy6puxA2Xk7HK4++lzoYsAtx65TEazW7+XlpQ09e3H25AGixbeodzoJ8QN0zmclDUCgDfPPrt30RaDVqxG5+tPs32yuP4ZNczQGP50gkivV3KBwN6Vs7+ReyljOtD1UhTmv0Hz5lIJpORviFIAbG5Og==</ds:SignatureValue><ds:KeyInfo Id=\"KI-F6DDC585AC5A582DD2142573691238412626\"><wsse:SecurityTokenReference xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"STR-F6DDC585AC5A582DD2142573691238412627\"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"id-8417\"><ns2:authorizeResponse xmlns:ns2=\"http://webservices.webpayserver.transbank.com/\"><return><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>-98</responseCode><transactionId>71686</transactionId></return></ns2:authorizeResponse></soap:Body></soap:Envelope>" }
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
          let(:body) { "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" soap:mustUnderstand=\"1\"><ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"SIG-8418\"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"soap\"></ec:InclusiveNamespaces></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></ds:SignatureMethod><ds:Reference URI=\"#id-8417\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"\"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></ds:DigestMethod><ds:DigestValue>A41MxtjtjqlDdpGaRgs646qfx54=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>thiXMidDm0LHzLgl88OPDMXUoKMp8U+Ps1oZG6llfF3MmFNjkRmsBcD/OitwindHrDeH0nW67OFLnuJtCFTWlW89tk8smRgec2G/MsAdapGeskDf5h3uuN79O6uCUWEkNzoeyA2l0+lthGmZeRRLLKlDn3fLFfom2XPA+T8ABhO1ZqY/W6TyJCVV3FIY94qhiiA2uuyy80UFpGQytUBAuR5HTov3MSIWXTcubPleJ7ev2QYU6Sc2YI22fS/S7JVGj2lGGGZQKo/4mCcPeSqprJF5RuU8ozB1SMnPcDUXRh1XO4AGkRrJ9IbMk9wqYHgMJWoWhINoVuz2ZXyF81279A==</ds:SignatureValue><ds:KeyInfo Id=\"KI-F6DDC585AC5A582DD2142573691238412626\"><wsse:SecurityTokenReference xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"STR-F6DDC585AC5A582DD2142573691238412627\"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"id-8417\"><ns2:authorizeResponse xmlns:ns2=\"http://webservices.webpayserver.transbank.com/\"><return><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>-97</responseCode><transactionId>71686</transactionId></return></ns2:authorizeResponse></soap:Body></soap:Envelope>" }
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
          let(:body) { "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" soap:mustUnderstand=\"1\"><ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"SIG-8418\"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"soap\"></ec:InclusiveNamespaces></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></ds:SignatureMethod><ds:Reference URI=\"#id-8417\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"\"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></ds:DigestMethod><ds:DigestValue>bE4QpMQ/0dJ1DioM4fdw7Aq8EpM=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>N9QRIXEsWkEcUyQ8CHLOn3JpZeW/BhJXgayxhU14Zgo3Dqlcf1PDjga0Bx4XqAi5SNYhpXBXszzj+MZ2gWLvvOWdbTIjNkzwZaFlUr+e92TtK6wAyT4iAKswMNQ3AkKpe0jw0An/RqFZ9iMG2obxwXqiDbFqF5yUTgqvOK1MXdpXRk7j97coqe9bzo9UusJiWJT7GIyxQ+PCl6yybrjpnklakDjZ4oRQ4Xe0HuwEQx7MXYtCqkkEWVXbapQHnO3NoRirAkhgzjzifpPFFj4tOYIjbrhVfAtlKjyukno3UFniQqY1WUEu4Sv0LlinR9X5yGBrIPmRuDtuvXOTETzckw==</ds:SignatureValue><ds:KeyInfo Id=\"KI-F6DDC585AC5A582DD2142573691238412626\"><wsse:SecurityTokenReference xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"STR-F6DDC585AC5A582DD2142573691238412627\"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"id-8417\"><ns2:authorizeResponse xmlns:ns2=\"http://webservices.webpayserver.transbank.com/\"><return><creditCardType>Visa</creditCardType><last4CardDigits>6623</last4CardDigits><responseCode>-99</responseCode><transactionId>71686</transactionId></return></ns2:authorizeResponse></soap:Body></soap:Envelope>" }
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
          let(:body) { "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" soap:mustUnderstand=\"1\"><ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"SIG-8432\"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"soap\"></ec:InclusiveNamespaces></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></ds:SignatureMethod><ds:Reference URI=\"#id-8431\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"\"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></ds:DigestMethod><ds:DigestValue>d5eiiC8lU9K+RwEa1fYFuCK2uOI=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>N4H295UU8whbP2g+gWETWIWDnceRqC0dhsjiIAu7C7Ia8SV0XNwJ4SYfF2EW/HWR9wZPy2R3vO0MnEBVywrr8QFTmXYrtzO1aZpWRr7pHYLDBZ94HVTGX9S9E6Q+AcGGv/x06K4cLkeFpcYCqge6vJnUa2qJRAql3gcnO4hcIueMat6hs++lEu+uMGC3yFi5t3JjFLKPe7qh151kekPmMZpfpCKxWtTH+VyfV45SLnP4rh2Mh3mKLXRv+yvydsFnsmLPlDJgqupqNc5HGyKh6hJZ8VUhLxpOOvW8GtE/jZ9GnzlF1/5nLk2kcRaQdQVsRHlTM3s+dU5TkqiU0J7IKQ==</ds:SignatureValue><ds:KeyInfo Id=\"KI-F6DDC585AC5A582DD2142573852294212647\"><wsse:SecurityTokenReference xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"STR-F6DDC585AC5A582DD2142573852294212648\"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"id-8431\"><ns2:codeReverseOneClickResponse xmlns:ns2=\"http://webservices.webpayserver.transbank.com/\"><return><reverseCode>3619160862457231902</reverseCode><reversed>true</reversed></return></ns2:codeReverseOneClickResponse></soap:Body></soap:Envelope>" }
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
          let(:body) { "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" soap:mustUnderstand=\"1\"><ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"SIG-8434\"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"soap\"></ec:InclusiveNamespaces></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></ds:SignatureMethod><ds:Reference URI=\"#id-8433\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"\"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></ds:DigestMethod><ds:DigestValue>/j2dFcNHzkq8gRjQkeA3DznM0h4=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>Llcih4vOhH1o8zf5Fei0oFK5y3MhFUnKuKw5oTP95pQhe+xvqXLB8J0I8L08+zgIgd68ekgEaLAMb7MzBz6PpADVfEkezFjedkmrATbZrBL0P+uxGi7bV/KNkEjGaaLfS0oZlQn77ieG3UGYYT894hlKMzdgoPZgzyUP31Sr91bxvmx6O9utRg9UED8JGiL2+bCytyzAdbA9ATg6TZudTD/jdLOfK8cMD7cz442SLNTvZXobUHGSKudVjKKfswc2Nu4nwcAna91f7TvW5f5VwjQXVjUuUo9/r4gQVX++S0Em4gdI3bOq3X2FnzlhmZDe5y9A+qjAhnnUeeTUfT5Xpw==</ds:SignatureValue><ds:KeyInfo Id=\"KI-F6DDC585AC5A582DD2142573918866412650\"><wsse:SecurityTokenReference xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"STR-F6DDC585AC5A582DD2142573918866412651\"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"id-8433\"><ns2:codeReverseOneClickResponse xmlns:ns2=\"http://webservices.webpayserver.transbank.com/\"><return><reversed>false</reversed></return></ns2:codeReverseOneClickResponse></soap:Body></soap:Envelope>" }
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
          let(:body) { "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><wsse:Security xmlns:wsse=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\" soap:mustUnderstand=\"1\"><ds:Signature xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\" Id=\"SIG-8436\"><ds:SignedInfo><ds:CanonicalizationMethod Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"soap\"></ec:InclusiveNamespaces></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#rsa-sha1\"></ds:SignatureMethod><ds:Reference URI=\"#id-8435\"><ds:Transforms><ds:Transform Algorithm=\"http://www.w3.org/2001/10/xml-exc-c14n#\"><ec:InclusiveNamespaces xmlns:ec=\"http://www.w3.org/2001/10/xml-exc-c14n#\" PrefixList=\"\"></ec:InclusiveNamespaces></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm=\"http://www.w3.org/2000/09/xmldsig#sha1\"></ds:DigestMethod><ds:DigestValue>BtK1c6IQQt90kV7NJUMfdDFWdjU=</ds:DigestValue></ds:Reference></ds:SignedInfo><ds:SignatureValue>RWBjf4xwgA2m0z2mcHxDRILaNF+T4UsFzMbqpDOUbUMRiyG5/2fvuqqOk3hX8IzAYYW7sNGDTCVfXs4Z0/iv83oFlS1da4uxs3RwG7W3C9pMS4g+2Ekry7nmQyD39BGVz/J7wLRf0e8rPgZmg2hxkBrGE5Ir1C4IWjq02lcErnoGPy1Lhd3vY/ZvIRXGy6Y893JO+bG3AQfEDA3Gn6pjdwL6OrYKU0EWd/vLQYT7f4xRSySg8XjgX3L0paT8c7ADgMTNaeeFEIeV0SSXy9GC32/zkNmNSCLoMBtGDi2oHFDIumf4GlV9C0lg1xKNBzePplL3gwIVoa9k9M8G8K3vxg==</ds:SignatureValue><ds:KeyInfo Id=\"KI-F6DDC585AC5A582DD2142573978894412653\"><wsse:SecurityTokenReference xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"STR-F6DDC585AC5A582DD2142573978894412654\"><ds:X509Data><ds:X509IssuerSerial><ds:X509IssuerName>C=CL,ST=Santiago,L=Santiago,O=DemoTbk,OU=DemoTbk,CN=10</ds:X509IssuerName><ds:X509SerialNumber>12876303082739064166</ds:X509SerialNumber></ds:X509IssuerSerial></ds:X509Data></wsse:SecurityTokenReference></ds:KeyInfo></ds:Signature></wsse:Security></soap:Header><soap:Body xmlns:wsu=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\" wsu:Id=\"id-8435\"><ns2:removeUserResponse xmlns:ns2=\"http://webservices.webpayserver.transbank.com/\"><return>true</return></ns2:removeUserResponse></soap:Body></soap:Envelope>" }
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
