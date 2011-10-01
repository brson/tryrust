getCode = () -> "some code"

setResult = (result) ->

submitCode = () ->
        $.post("api/run", getCode())

$(document).ready ->
        inputArea = document.getElementById("inputarea")
        outputArea = document.getElementById("outputarea")
        theme = "default"
        cmInput = CodeMirror.fromTextArea(
                inputArea,
                {theme: theme})
        cmOutput = CodeMirror.fromTextArea(
                outputArea,
                {theme: theme})

        $("#submit-btn").click(submitCode)

