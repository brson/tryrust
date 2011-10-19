$(document).ready ->
  client = window.tryRustClient;

  inputArea = document.getElementById("inputarea")
  outputArea = document.getElementById("outputarea")
  theme = "default"
  cmInput = CodeMirror.fromTextArea(
    inputArea,
    {theme: theme})
  cmOutput = CodeMirror.fromTextArea(
    outputArea,
    {theme: theme})

  $("#submit-btn").click () ->
    client.submitCode cmInput.getValue(), (result) ->
      cmOutput.setValue result.runStdOut


