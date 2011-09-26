$(document).ready ->
        inputArea = document.getElementById("inputarea")
        outputArea = document.getElementById("outputarea")
        theme = "cobalt"
        cmInput = CodeMirror.fromTextArea(
                inputArea,
                {theme: theme})
        cmOutput = CodeMirror.fromTextArea(
                outputArea,
                {theme: theme})