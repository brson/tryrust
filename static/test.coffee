client = window.tryRustClient

test "test", () ->
  client.submitCode("test", () ->)