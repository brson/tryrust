cmTheme = "default"
cmMode = "rust"

$(document).ready ->
  client = window.tryRustClient;

  inputArea = document.getElementById("inputarea")
  outputArea = document.getElementById("outputarea")
  cmInput = CodeMirror.fromTextArea(
    inputArea, {
      mode: "rust"
      theme: cmTheme
    })
  cmOutput = CodeMirror.fromTextArea(
    outputArea, {
      mode: "none"
      theme: cmTheme
    })

  $("#submit-btn").click () ->
    client.submitCode cmInput.getValue(), (result) ->
      cmOutput.setValue result.runStdOut


