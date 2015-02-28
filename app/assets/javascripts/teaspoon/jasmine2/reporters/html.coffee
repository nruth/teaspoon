class Teaspoon.Reporters.HTML extends Teaspoon.Reporters.HTML

  readConfig: ->
    super
    jasmine.CATCH_EXCEPTIONS = @config["use-catch"]


  envInfo: ->
    "jasmine #{jasmine.version}"


  suiteStarted: (result) ->
    if @currentSuite # suite already running, we're nested
      result.parent = @currentSuite
    @currentSuite = result


  suiteDone: (result) ->
    @currentSuite = @currentSuite.parent


  specStarted: (result) ->
    result.parent = @currentSuite
    @reportSpecStarting(result)


  specDone: (result) ->
    result.parent = @currentSuite
    @reportSpecResults(result)
