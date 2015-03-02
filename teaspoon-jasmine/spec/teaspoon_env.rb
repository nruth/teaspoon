Teaspoon.configure do |config|
  path = "teaspoon-jasmine/spec/javascripts"
  config.asset_paths << Teaspoon::Engine.root.join(path)
  config.suite :jasmine do |suite|
    suite.use_framework :jasmine
    suite.matcher = "#{path}/**/*_spec.{js,js.coffee,coffee}"
    suite.helper = "jasmine_helper"
    # suite.body_partial = "/body"
  end
end
