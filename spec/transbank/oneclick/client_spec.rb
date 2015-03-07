require 'spec_helper'

module Transbank
  module Oneclick

    describe Client do
      let(:client) { Client.new read_timeout: 55, open_timeout: 55}

      describe 'check default options' do
        it { client.http.use_ssl?.must_equal true }
        it { client.http.verify_mode.must_equal OpenSSL::SSL::VERIFY_NONE }
      end

      describe 'check options' do
        it { client.http.read_timeout.must_equal 55 }
        it { client.http.open_timeout.must_equal 55 }
      end

      describe '#post' do
        it 'init incription'do
          stub_request(:post, 'https://transbank-example.cl/oneclick')
            .with(body: INIT_INSCRIPTION_XML, headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/soap+xml; charset=utf-8', 'User-Agent'=>'Ruby'})
            .to_return(status: 200, body: "", headers:{})

          client.post(INIT_INSCRIPTION_XML).code.must_equal '200'
        end
      end
    end
  end
end