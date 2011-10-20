static = require 'node-static'
http = require 'http'
fs = require 'fs'
child_process = require 'child_process'

workdir = 'work'
filemode = 0777
rtfailexit = 101

makeFileNames = () ->
  rundir = workdir + '/' + (Math.floor(Math.random() * 0xFFFFFFFF)).toString(16)
  return {
    rundir: rundir
    codefile: rundir + '/' + "main.rs"
    exefile: rundir + '/' + "main"
  }

buildWorkdir = (callback) ->
  console.log 'Building work directory'
  # FIXME: What if this fails?
  fs.mkdir workdir, filemode, () ->
    callback
      success: true

buildRundir = (rundir, callback) ->
  console.log 'Building run directory'
  # FIXME: What if this fails?
  fs.mkdir rundir, filemode, () ->
    callback
      success: true

writeCode = (code, codefile, callback) ->
  console.log 'Writing code to file ' + codefile
  fs.writeFile codefile, code, (err) ->
    # FIXME: err
    callback
      success: true

buildCode = (codefile, exefile, callback) ->
  console.log 'Building code'
  command = 'rustc ' + codefile + ' -o ' + exefile
  console.log 'Command = ' + command
  child_process.exec command, (error, stdout, stderr) ->
    if error? && error.code == rtfailexit
      callback
        success: false
        errormsg: "Compilation failed"
        compStdOut: stdout
        compStdErr: stderr
    else
      callback
        success: true
        compStdOut: stdout
        compStdErr: stderr

runCode = (exefile, callback) ->
  console.log 'Running code'
  child_process.exec exefile, (error, stdout, stderr) ->
    callback
      success: true
      runStdOut: stdout
      runStdErr: stderr

cleanup = (fileNames) ->
  fs.unlink fileNames.exefile
  fs.unlink fileNames.codefile
  fs.rmdir fileNames.rundir

run = (code, callback) ->
  buildWorkdir (result) ->
    fileNames = makeFileNames()
    buildRundir fileNames.rundir, (result) ->
      writeCode code, fileNames.codefile, (result) ->
        buildCode fileNames.codefile, fileNames.exefile, (result) ->
          compStdOut = result.compStdOut
          compStdErr = result.compStdErr
          if result.success
            runCode fileNames.exefile, (result) ->
              callback
                success: result.success
                compStdOut: compStdOut
                compStdErr: compStdErr
                runStdOut: result.runStdOut
                runStdErr: result.runStdErr
              cleanup fileNames
          else
            callback result
            cleanup fileNames

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

    run runObj.code, (result) ->
      console.log "Returning result"
      console.log result
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

