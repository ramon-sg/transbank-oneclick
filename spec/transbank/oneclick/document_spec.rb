require 'spec_helper'

module Transbank
  module Oneclick
    describe Document do
      before { Document.any_instance.stubs(:body_id).returns('dge763trgad') }

      it 'action init inscription' do
        doc = Document.new :init_inscription, email: "username@domain",
                                              username: "username",
                                              response_url: "http://domain/card"
        doc.canonicalize.to_s.must_equal INIT_INSCRIPTION_XML
      end

      it 'action finish inscription' do
        doc = Document.new :finish_inscription, token: 'fyegwyufgi3289rheowifewfiasocgh2e78c'
        doc.canonicalize.to_s.must_equal FINISH_INSCRIPTION_XML
      end

      it 'action authorize' do
        doc = Document.new :authorize,  amount: 99999,
                                        tbk_user: '35700491-cb03-4bbb-8ab7-29dd7b0771ab',
                                        username: 'user_1',
                                        buy_order: '20110715115550003'
        doc.canonicalize.to_s.must_equal AUTHORIZE_XML
      end

      it 'action reverse' do
        doc = Document.new :code_reverse_one_click, buy_order: '20110715115550003'
        doc.canonicalize.to_s.must_equal REVERSE_XML
      end

      it 'action remove user' do
        doc = Document.new :remove_user,  tbk_user: '35700491-cb03-4bbb-8ab7-29dd7b0771ab',
                                          username: 'user_1'
        doc.canonicalize.to_s.must_equal REMOVE_USER_XML
      end
    end
  end
end