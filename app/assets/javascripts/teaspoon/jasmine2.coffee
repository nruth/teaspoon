#= require teaspoon/base/teaspoon
#= require teaspoon/jasmine2/reporters/html

unless jasmineRequire?
  throw new Teaspoon.Error('Jasmine 2 not found -- use `suite.use_framework :jasmine` and adjust or remove the `suite.javascripts` directive.')

class Teaspoon.Runner extends Teaspoon.Runner

  constructor: ->
    super
    env.execute()


  setup: ->
    env.updateInterval = 1000

    # add the spec filter
    if grep = @params["grep"]
      env.specFilter = (spec) -> return spec.getFullName().indexOf(grep) == 0

    # add the reporter and set the filter
    reporter = new (@getReporter())()
    env.addReporter(reporter)

    # add fixture support
    # @addFixtureSupport()


  addFixtureSupport: ->
    return unless jasmine.getFixtures && @fixturePath
    jasmine.getFixtures().containerId = "teaspoon-fixtures"
    jasmine.getFixtures().fixturesPath = @fixturePath
    jasmine.getStyleFixtures().fixturesPath = @fixturePath
    jasmine.getJSONFixtures().fixturesPath = @fixturePath



class Teaspoon.Spec

  constructor: (@spec, @suite) ->
    @fullDescription = @spec.fullName
    @description = @spec.description
    @link = "?grep=#{encodeURIComponent(@fullDescription)}"
    @parent = @suite
    @suiteName = @parent?.fullName || 'Unknown!?'
    @viewId = @spec.id
    @pending = @spec.status == "pending"


  errors: ->
    return [] unless @spec.failedExpectations.length
    for item in @spec.failedExpectations
      {message: item.message, stack: item.stack}


  result: ->
    status: @status()
    skipped: @spec.status == "disabled"


  status: ->
    if @spec.status == "disabled" then "passed" else @spec.status



class Teaspoon.Suite

  constructor: (@suite) ->
    @fullDescription = @suite.getFullName()
    @description = @suite.description
    @link = "?grep=#{encodeURIComponent(@fullDescription)}"
    @parent = @suite.parentSuite
    @viewId = @suite.viewId



class Teaspoon.fixture extends Teaspoon.fixture

  window.fixture = @

  @load: ->
    args = arguments
    throw "Teaspoon can't load fixtures outside of describe." unless env.currentSuite || env.currentSpec
    if env.currentSuite
      env.beforeEach => fixture.__super__.constructor.load.apply(@, args)
      env.afterEach => @cleanup()
      super
    else
      env.currentSpec.after => @cleanup()
      super


  @set: ->
    args = arguments
    throw "Teaspoon can't load fixtures outside of describe." unless env.currentSuite || env.currentSpec
    if env.currentSuite
      env.beforeEach => fixture.__super__.constructor.set.apply(@, args)
      env.afterEach => @cleanup()
      super
    else
      env.currentSpec.after => @cleanup()
      super


extend = (destination, source) ->
  for property of source
    destination[property] = source[property]
  destination

# set the environment
window.jasmine = jasmineRequire.core(jasmineRequire)
env = jasmine.getEnv()
jasmineInterface = jasmineRequire.interface(jasmine, env)
extend(window, jasmineInterface)
