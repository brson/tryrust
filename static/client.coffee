submitCode = (code, callback) -> submitCode$($, code, callback)

submitCode$ = ($, code, callback) ->
  $.post("api/run", JSON.stringify({
    code: code
  }))
  .success () ->
    callback({
      success: true
    })
  .error () ->
    callback({
      success: false
    })

window.tryRustClient =
  submitCode: submitCode
  submitCode$: submitCode$
