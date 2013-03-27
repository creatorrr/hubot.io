# Hubot.io

This is an external [hubot-script](https://github.com/github/hubot/blob/master/README.md#external-scripts) that attaches a [socket.io](http://socket.io/) instance to [Hubot](http://hubot.github.com/)'s HTTP Listener. Because, why not?

## Installing

1. Add `hubot.io` as a dependency to your hubot:
    `"hubot.io": ">= 0.1.0"`
2. Tell hubot to load it. Add `"hubot.io"` to the `external-scripts.json` list in the hubot root folder.
3. `npm install` while you grab a beer.
4. _Optional_ but **highly recommended**, set environment variable `NODE_ENV` to `production`.

## Usage & Examples

Initialize your [socket.io](http://socket.io/) code by attaching callback to the `sockets:connection` event on hubot and proceed to use [socket.io](http://socket.io/) as usual.

```coffeescript
module.exports = (robot) ->
  robot.on 'sockets:connection', (socket) ->
    socket.emit 'news', hello: 'world'
    socket.on 'other event', (data) -> console.log data

  # Don't forget to include client-side code
  robot.router.get '/', (req, res) ->
    res.writeHead 200, 'Content-Type': 'text/html'
    res.end '''
      <script src="/socket.io/socket.io.js"></script>
      <script>
        var socket = io.connect('http://localhost');
        socket.on('news', function (data) {
          console.log(data);
          socket.emit('my other event', { my: 'data' });
        });
      </script>
      <body>
        <!-- Blah blah. -->
      </body>
    '''
```

## Contributing

Patches, bugs, ideas, love? Ping me.

## License

Copyright (c) 2013, Diwank Singh <singh@diwank.name>
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
