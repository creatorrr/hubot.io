# Description:
#   Attaches a socket.io server to the HTTP server.
#
# Dependencies:
#   "socket.io": "0.9.x"
#
# Configuration:
#   "NODE_ENV": "production"
#
# Commands:
#   None
#
# Author:
#   creatorrr


# Configure socket.io
configure = (io) ->
  onHeroku = process.env.HEROKU_URL

  # Declare environment using NODE_ENV environment variable.
  io.configure 'production', ->
    io.enable 'browser client minification'    # Send minified client
    io.enable 'browser client etag'            # Apply etag caching logic based on version
    io.enable 'browser client gzip'            # Gzip the file

    io.set 'log level', 1
    io.set 'transports', if onHeroku? then [
      # Heroku does not support websockets.
      # (https://devcenter.heroku.com/articles/using-socket-io-with-node-js-on-heroku)
      'xhr-polling'
      'jsonp-polling'
    ] else [
      'websocket'
      'flashsocket'
      'htmlfile'
      'xhr-polling'
      'jsonp-polling'
    ]

  io.configure 'development', ->
    io.set 'transports', ['websocket']

# Get namespaced event.
getSocketsEvent = (event) -> (/^sockets:(.+)/i.exec event)?[1]

module.exports = (robot) ->
  throw new Error 'HTTP server not available' unless (server = robot.server)?

  # Attach socket.io to http server and configure it.
  io = (require 'socket.io').listen server
  configure io

  # All socket.io events need to be namespaced to avoid collision.
  # In this case, 'sockets:*' events will be parsed and attached to the socket.io instance.
  #
  # So ```robot.on 'sockets:connection', callback```
  # will fire ```io.sockets.on 'connection', callback```
  robot.on 'newListener', (event, listener) ->
    if (event = getSocketsEvent event)?
      robot.logger.debug "Listening to socket.io event: #{ event }"
      io.sockets.on event, listener

  robot.on 'removeListener', (event, listener) ->
    if (event = getSocketsEvent event)?
      io.sockets.removeListener event, listener

  # Return socket.io instance
  io
