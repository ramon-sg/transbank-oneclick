require 'spec_helper'
class TransbankOneclickGeneratorSpec < Rails::Generators::TestCase
  tests TransbankOneclick::Generators::InstallGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination
  teardown { rm_rf(destination_root) }

  test "Assert all files are properly created" do
    run_generator
    assert_file 'config/initializers/transbank_oneclick.rb'
  end
end