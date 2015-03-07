require 'spec_helper'

module Transbank
  module Oneclick
    describe Api do

      let(:api){ Api.new }

      describe '#build_params' do
        it { api.send( :build_params, {email: 'email'} ).keys.must_include :email }
        it { api.send( :build_params, {response_url: 'response_url'} ).keys.must_include :responseURL }
        it { api.send( :build_params, {token: 'token'} ).keys.must_include :token }
        it { api.send( :build_params, {amount: 'amount'} ).keys.must_include :amount }
        it { api.send( :build_params, {tbk_user: 'tbk_user'} ).keys.must_include :tbkUser }
        it { api.send( :build_params, {buy_order: 'buy_order'} ).keys.must_include :buyOrder }
      end
    end
  end
end