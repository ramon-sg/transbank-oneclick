require 'spec_helper'

module Transbank
  module Oneclick
    describe ExceptionResponse do
      let(:raise_error) { URI::InvalidURIError.new 'the scheme http does not accept registry part: :80 (or bad hostname?)>' }
      let(:exception_response) { ExceptionResponse.new raise_error, :initi_inscription}

      it{ exception_response.valid?.must_equal false }

      it{ exception_response.errors.must_include 'the scheme http does not accept registry part: :80 (or bad hostname?)>' }

      it { exception_response.exception?.must_equal true }

      it { exception_response.errors_display.must_equal 'URI::InvalidURIError, the scheme http does not accept registry part: :80 (or bad hostname?)>' }

      it { exception_response.errors_display.inspect.must_equal '"URI::InvalidURIError, the scheme http does not accept registry part: :80 (or bad hostname?)>"'}
    end
  end
end