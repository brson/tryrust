client = window.tryRustClient

test "submit not-json", 1, () ->
  stop()
  $.post("api/run", "garbage")
  .error(() ->
    ok(true)
    start()
  )
  .success(() ->
    ok(false)
    start()
  )