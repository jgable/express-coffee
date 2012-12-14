fs            = require 'fs'
{print}       = require 'util'
which         = require('which')
{spawn, exec} = require 'child_process'

# ANSI Terminal Colors
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

pkg = JSON.parse fs.readFileSync('./package.json')
testCmd = pkg.scripts.test
startCmd = pkg.scripts.start
  

log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

run = (cmd, env = {}, callback) ->
  args = cmd.split " "

  exec = spawn args[0], args.slice(1), env

  exec.stdin.pipe process.stdin
  exec.stdout.pipe process.stdout
  exec.stderr.pipe process.stderr

  exec.on 'exit', (status) -> callback?() if status is 0

# Compiles app.coffee and src directory to the app directory
build = (callback) ->
  options = ['-c','-b', '-o', 'app', 'src']
  cmd = which.sync 'coffee'
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  coffee.on 'exit', (status) -> callback?() if status is 0

upload = (callback) ->
  # Set production NODE_ENV
  currentEnv = process.env
  currentEnv.NODE_ENV = "production"

  run "node s3.js", currentEnv, callback

deploy = (callback) ->
  # NOTE: Doesn't work because of something wrong with input parser
  run 'jitsu deploy -c', null, callback

# mocha test
test = (callback) ->
  options = [
    '--compilers'
    'coffee:coffee-script'
    '--colors'
    '--require'
    'should'
    '--require'
    './server'
  ]
  try
    cmd = which.sync 'mocha' 
    spec = spawn cmd, options
    spec.stdout.pipe process.stdout 
    spec.stderr.pipe process.stderr
    spec.on 'exit', (status) -> callback?() if status is 0
  catch err
    log err.message, red
    log 'Mocha is not installed - try npm install mocha -g', red

task 'docs', 'Generate annotated source code with Docco', ->
  fs.readdir 'src', (err, contents) ->
    files = ("src/#{file}" for file in contents when /\.coffee$/.test file)
    try
      cmd = which.sync 'docco' 
      docco = spawn cmd, files
      docco.stdout.pipe process.stdout
      docco.stderr.pipe process.stderr
      docco.on 'exit', (status) -> callback?() if status is 0
    catch err
      log err.message, red
      log 'Docco is not installed - try npm install docco -g', red

task 'build', ->
  build -> log ":)", green

task 'spec', 'Run Mocha tests', ->
  build -> test -> log ":)", green

task 'test', 'Run Mocha tests', ->
  build -> test -> log ":)", green

task 'dev', 'start dev env', ->
  # watch_coffee
  options = ['-c', '-b', '-w', '-o', 'app', 'src']
  cmd = which.sync 'coffee'  
  coffee = spawn cmd, options
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  log 'Watching coffee files', green
  # watch_js
  supervisor = spawn 'node', ['./node_modules/supervisor/lib/cli-wrapper.js','-w','app,views', '-e', 'js|jade', 'server.js']
  supervisor.stdout.pipe process.stdout
  supervisor.stderr.pipe process.stderr
  log 'Watching js files and running server', green

task 'live', 'start production server', ->
  log 'Building files', green
  build ->
    log 'Starting production server', green
    
    # Set production NODE_ENV
    currentEnv = process.env
    currentEnv.NODE_ENV = "production"

    server = spawn 'node', ['server.js'],
      env: currentEnv

    server.stdout.pipe process.stdout
    server.stderr.pipe process.stderr

task 's3', 'Upload builtAssets', ->
  log "Uploading to S3", green
  build ->
    upload ->
      log "Done", green

task 'deploy', 'Deploy to production', ->
  log "Deploying to production", green
  build ->
    upload ->
      deploy ->
        log "Done", green
