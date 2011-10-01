static = require 'node-static'

file = new static.Server './static'

http = require 'http'

http.createServer( (req, res) ->
        req.addListener('end', () ->
                file.serve(req, res)
        )
).listen 8080

