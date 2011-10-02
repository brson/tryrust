static = require 'node-static'
http = require 'http'

collect_data = (request, callback) ->
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
  collect_data(request, (reqstr) ->
    console.log(reqstr)
    response.writeHead(200, {'Content-Type': 'text/json'})
    response.end()
  )

file = new static.Server './static'

http.createServer( (req, res) ->
  console.log("Request for " + req.url)
  if req.url.indexOf("/api") == 0
    handleApi(req, res)
  else
    req.addListener('end', () -> file.serve(req, res))
).listen 8080

console.log("Listening on port 8080")

