static = require 'node-static'

file = new static.Server './static'

http = require 'http'

http.createServer( (req, res) ->
        req.addListener('end', () ->
                file.serve(req, res)
        )
).listen 8080

###
http = require "http"

http.createServer( (req, res) ->
        console.log "Got request"
        res.writeHead(200, {"Content-Type": 'text/plain'});
        res.end("Hello World\n");
).listen 8080

console.log("Server running at http://127.0.0.1:8080/");
###