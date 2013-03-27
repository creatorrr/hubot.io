fs = require 'fs'

{print} = require 'sys'
{spawn} = require 'child_process'

build = (callback, opts...) ->
  options = ['-c', 'index.coffee']
  options.unshift opts... if opts
  coffee = spawn 'coffee', options
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0

task 'build', 'Build index.coffee', build
task 'watch', 'Watch and build index.coffee', -> build null, '-w'
