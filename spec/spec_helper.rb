require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/unit'
require 'active_support'
require 'rails/generators'
require 'rails/generators/test_case'
require 'generators/transbank_oneclick/install/install_generator'
require 'transbank-oneclick'

ActiveSupport.test_order = :sorted