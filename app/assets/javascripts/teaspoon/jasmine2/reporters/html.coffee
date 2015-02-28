class Teaspoon.Reporters.HTML extends Teaspoon.Reporters.HTML

  constructor: ->
    super
    @_suites = []
    @suites_hash = {}
    @specs = []
    @executionTime = null

  readConfig: ->
    super
    jasmine.CATCH_EXCEPTIONS = @config["use-catch"]


  envInfo: ->
    "jasmine #{jasmine.version}"

  # jasmineStarted: ->
  #   @deb()
  #   @started = true
  #   @status = 'started'
  #   # timer.start()

  # jasmineDone: ->
  #   @deb()
  #   @finished = true
  #   # @executionTime = timer.elapsed()
  #   @status = 'done'

  suiteStarted: (result) ->
    @currentSuite = result

  # suiteDone: (result) ->
  #   @deb()
  #   @storeSuite(result)

  # suiteResults: (index, length) ->
  #   @deb()
  #   @_suites.slice(index, index + length)

  # storeSuite: (result) ->
  #   @deb()
  #   @_suites.push(result)
  #   @suites_hash[result.id] = result

  # suites: ->
  #   @deb()
  #   @suites_hash

  specStarted: (result) ->
    @reportSpecStarting(result, @currentSuite)

  specDone: (result) ->
    @deb()
    @reportSpecResults(result)
    # @specs.push(result)

  # specResults: (index, length) ->
  #   @deb()
  #   @specs.slice(index, index + length)

  deb: ->
    # debugger

  reportSpecStarting: (spec, suite) ->
    spec = new Teaspoon.Spec(spec, suite)
    @reportView = new Teaspoon.Reporters.HTML.SpecView(spec, @) if @config["build-full-report"]
    @specStart = new Teaspoon.Date().getTime()
