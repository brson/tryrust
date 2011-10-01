static = require 'node-static'
http = require 'http'

handleApi = (req, res) ->
        console.log("Handling an API request")

file = new static.Server './static'

http.createServer( (req, res) ->
        console.log("Request for " + req.url)
        req.addListener('end', () ->
                if req.url.indexOf("/api") == 0
                        handleApi(req, res)
                else
                        file.serve(req, res)
        )
).listen 8080

console.log("Listening on port 8080")

