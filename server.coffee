static = require 'node-static'
http = require 'http'
fs = require 'fs'

runCode = (code, callback) ->
  callback
    output: "hello"

collectData = (request, callback) ->
  console.log('Collecting data')
  collected = ''
  request.addListener('data', (chunk) ->
    console.log("Got chunk: #{chunk}")
    collected += chunk
  )
  request.addListener('end', () ->
    callback(collected)
  )

handleApi = (request, response) ->
  console.log("Handling an API request")
  collectData request, (reqstr) ->
    console.log(reqstr)

    runObj = null
    try
      runObj = JSON.parse(reqstr)
    catch error
      console.log("Unable to parse request")
      response.writeHead(400)
      response.end()
      return

    if !runObj.code?
      console.log("No code field in request")
      response.writeHead(400)
      response.end()
      return

    runCode runObj.code, (result) ->
      console.log "Returning result"
      response.writeHead(200, {'Content-Type': 'text/json'})
      response.write(JSON.stringify(result))
      response.end()

file = new static.Server './static'

http.createServer( (req, res) ->
  console.log("Request for " + req.url)
  if req.url.indexOf("/api") == 0
    handleApi(req, res)
  else
    req.addListener('end', () -> file.serve(req, res))
).listen 8080

console.log("Listening on port 8080")

