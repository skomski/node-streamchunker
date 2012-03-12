{ Stream } = require 'stream'

END_OF_FILE = {}

class StreamChunk extends Stream
  module.exports = StreamChunk
  constructor: (options) ->
    super

    @position       = options.position       || 0
    @streamPosition = options.streamPosition
    @readable = true

    @_paused = false
    @_pendings = []


  write: (buffer) ->
    if @_paused or @_pendings.length
      @_pendings.push buffer
    else
      @emit 'data', buffer

  end: () ->
    @readable = false

    if @_paused || @_pendings.length
      @_pendings.push END_OF_FILE
    else
      @emit 'end'

  pause: () ->
    @_paused = true

  resume: () ->
    @_paused = false

    if @_pendings.length
      process.nextTick () =>
        while !@_paused && @_pendings.length
          chunk = @_pendings.shift()

          if chunk != END_OF_FILE
            @emit 'data', chunk
          else
            @readable = false
            @emit 'end'
