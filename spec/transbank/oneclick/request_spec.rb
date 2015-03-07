require 'spec_helper'

module Transbank
  module Oneclick
    describe Request do

      # Mocks
      before do
        client = mock()
        client.expects(:post).with(INIT_INSCRIPTION_XML).returns(:post_result)
        Client.stubs(:new).returns(client)

        document = mock()
        document.expects(:canonicalize).returns(INIT_INSCRIPTION_XML)
        Document.stubs(:new).returns(document)

        ExceptionResponse.stubs(:new).returns(:exception_response)
      end

      let(:request) { Request.new :init_inscription }

      describe '#response' do

        describe 'without error' do
          before { Response.stubs(:new).with(:post_result, :init_inscription).returns(:response) }
          it { request.response.must_equal :response }
        end

        describe 'with error' do
          before { Response.stubs(:new).with(:post_result, :init_inscription).raises(Net::ReadTimeout) }
          it { request.response.must_equal :exception_response }
        end
      end
    end
  end
end