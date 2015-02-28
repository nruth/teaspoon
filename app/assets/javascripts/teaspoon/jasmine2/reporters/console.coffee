class Teaspoon.Reporters.Console extends Teaspoon.Reporters.Console

  jasmineStarted: ->
    @reportRunnerStarting()


  reportRunnerStarting: ->
    @currentAssertions = []
    @log
      type:  "runner"
      total: null
      start: JSON.parse(JSON.stringify(@start))


  jasmineDone: ->
    @reportRunnerResults()


  reportRunnerResults: =>
    @log
      type:    "result"
      elapsed: ((new Teaspoon.Date().getTime() - @start.getTime()) / 1000).toFixed(5)
      coverage: window.__coverage__
    Teaspoon.finished = true

  suiteStarted: (result) ->
    @currentSuite = result


  specDone: (result) ->
    @reportSpecResults(result)


  reportSpecResults: (spec) ->
    @spec = new Teaspoon.Spec(spec, @currentSuite)
    result = @spec.result()
    return if result.skipped
    @reportSuites()
    switch result.status
      when "pending" then @trackPending()
      when "failed" then @trackFailure()
      else
        @log
          type:    "spec"
          suite:   @spec.suiteName
          label:   @spec.description
          status:  result.status
          skipped: result.skipped
