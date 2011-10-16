timeout = 1000

submitCode = (code, callback) -> submitCode$($, code, callback)

submitCode$ = ($, code, callback) ->
  submitCodeTimeout$ $, code, timeout, callback

submitCodeTimeout$ = ($, code, timeout, callback) ->

  timedout = false
  timerId = null

  timeoutFn = () ->
    timedout = true
    callback
      success: false
      errmsg: "Request timed out"

  timerId = setTimeout timeoutFn, timeout

  $.post("api/run", JSON.stringify({
    code: code
  }))
  .success () ->
    if !timedout
      clearTimeout timerId
      callback({
        success: true
      })
  .error () ->
    if !timedout
      clearTimeout timerId
      callback({
        success: false
        errmsg: "Server error"
      })

window.tryRustClient =
  submitCode: submitCode
  submitCode$: submitCode$
  submitCodeTimeout$: submitCodeTimeout$
