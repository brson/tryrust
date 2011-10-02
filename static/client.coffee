submitCode = (code, callback) ->
  $.post("api/run", JSON.stringify({
    code: code
  }))

window.tryRustClient =
  submitCode: submitCode