submitCode = (code) ->
  $.post("api/run", code)

window.tryRustClient =
  submitCode: submitCode