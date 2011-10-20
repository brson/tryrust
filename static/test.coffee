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

test "run no-code", () ->
  expect(1)
  stop()
  $.post("api/run", JSON.stringify({nocodehere: "whatever"}))
  .error () ->
    ok(true)
    start()

test "submit success", () ->
  expect(1)
  stop()
  client.submitCode "fn main(){}", (result) ->
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

test "run basic", () ->
  expect(2)
  stop()
  client.submitCode 'fn main(){log_err "hello";}', (result) ->
    ok(result.success)
    ok(result.runStdOut.indexOf("hello") != -1)
    start()

test "compile fail", () ->
  expect(2)
  stop()
  client.submitCode 'fn main{}', (result) ->
    ok(!result.success)
    ok(result.compStdOut.indexOf('expecting') != -1)
    start()