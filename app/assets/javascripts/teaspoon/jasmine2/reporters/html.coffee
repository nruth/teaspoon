class Teaspoon.Reporters.HTML extends Teaspoon.Reporters.HTML

  readConfig: ->
    super
    jasmine.CATCH_EXCEPTIONS = @config["use-catch"]


  envInfo: ->
    "jasmine #{jasmine.version}"


  jasmineStarted: (result) ->
    @reportRunnerStarting(total: result.totalSpecsDefined)


  suiteStarted: (result) ->
    if @currentSuite # suite already running, we're nested
      result.parent = @currentSuite
    @currentSuite = result


  suiteDone: (result) ->
    @currentSuite = @currentSuite.parent


  specDone: (result) ->
    result.parent = @currentSuite
    @reportSpecStarting(result) unless result.status == 'disabled'
    @reportSpecResults(result)
