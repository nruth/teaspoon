# Set RAILS_ROOT and load the environment if it's not already loaded.
unless defined?(Rails)
  ENV["RAILS_ROOT"] = File.expand_path("../dummy", __FILE__)
  require File.expand_path("../dummy/config/environment", __FILE__)
end

Teaspoon.configure do |config|
  config.root = Teaspoon::Engine.root
  config.asset_paths << Teaspoon::Engine.root.join("lib/teaspoon")

  config.suite do |suite|
    roots = "spec/javascripts,spec/dummy/app/assets/javascripts/specs"
    suite.matcher = "{#{roots}}/**/*_spec.{js,js.coffee,coffee,js.coffee.erb}"
    suite.javascripts = ["jasmine/1.3.1", "teaspoon/jasmine"]
  end

  config.suite :mocha do |suite|
    suite.matcher = "spec/javascripts/**/*_mspec.{js,js.coffee,coffee}"
    suite.javascripts = ["mocha/1.17.1", "teaspoon/mocha"]
    suite.helper = "mocha_helper"
  end

  config.suite :qunit do |suite|
    suite.matcher = "test/javascripts/**/*_test.{js,js.coffee,coffee}"
    suite.javascripts = ["qunit/1.14.0", "teaspoon/qunit"]
    suite.helper = "qunit_helper"
  end

  # config.suite :integration do |suite|
  #   suite.matcher = "spec/dummy/app/assets/javascripts/integration/*_spec.{js,js.coffee,coffee}"
  #   suite.helper = nil
  # end
end
require_relative "../teaspoon-jasmine/spec/teaspoon_env"
