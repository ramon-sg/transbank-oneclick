require "net/https"
require "uri"
require "nokogiri"

require "transbank/oneclick/version"
require "transbank/oneclick/api"
require "transbank/oneclick/client"
require "transbank/oneclick/document"
require "transbank/oneclick/request"
require "transbank/oneclick/response"
require "transbank/oneclick/exception_response"
require "transbank/oneclick/configuration"
require "transbank/oneclick/exceptions"

module Transbank
  module Oneclick
    class << self
      attr_accessor :configuration

      # Delegate api
      Api.instance_methods.each {|m|define_method(m){|*args| api.send(m, *args)}}
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def self.api
      @api ||= Api.new
    end
  end
end

