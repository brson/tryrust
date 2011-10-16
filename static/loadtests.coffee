$.ajaxSetup ({
  cache: false})

$(document).ready ->
  loadCoffee = (files) ->
    $head = $ "head"
    load = (file) ->
      $.get file, (content) ->
        try
          compiled = CoffeeScript.compile content, {bare: on}
          $("<script />").attr("type", "text/javascript").html(compiled).appendTo $head
        catch error
          console.error error.message
    load file for file in files
  loadCoffee ["test.coffee"]


