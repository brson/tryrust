client = window.tryRustClient

mockjqXHR =
  error: (callback) ->
    callback {
      success: false
    }
    mockjqXHR
  success: (callback) ->
    mockjqXHR

mock$ =
  post: (url, data) ->
    mockjqXHR

test "run not-json", () ->
  expect(1)
  stop()
  $.post("api/run", "garbage")
  .error () ->
    ok(true)
    start()

test "submit success", () ->
  expect(1)
  stop()
  client.submitCode "main(){}", (result) ->
    ok(result.success)
    start()

test "submit with error response", () ->
  expect(2)
  client.submitCode$ mock$, "code", (result) ->
    ok(!result.success)
    ok(result.errmsg == "Server error")

test "submit timeout", () ->
  expect(2)
  mock =
    post: (url, data) ->
      success: () -> this
      error: () -> this
  stop()
  client.submitCodeTimeout$ mock, "code", 10, (result) ->
    ok(!result.success)
    ok(result.errmsg == "Request timed out")
    start()
