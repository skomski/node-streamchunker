{ Stream }  = require 'stream'
StreamChunk = require './StreamChunk'

class StreamChunker extends Stream
  module.exports = StreamChunker

  constructor: (options) ->
    super

    @chunkSize     = options.chunkSize
    @startPosition = options.startPosition || 0
    @chunkCount    = 0
    @writable      = true

    @_streamChunk  = undefined

  _createStreamChunk: (options) ->
    @_streamChunk = new StreamChunk
      position: if @chunkCount > 0 then 0 else @startPosition
      streamPosition: @chunkCount * @chunkSize
    @emit 'chunk', @_streamChunk
    @chunkCount++

  write: (buffer) ->
    unless @_streamChunk
      @_createStreamChunk()


    if buffer.length + @_streamChunk.position > @chunkSize
      written = 0

      while buffer.length - written + @_streamChunk.position > @chunkSize
        oldBuffer = new Buffer @chunkSize - @_streamChunk.position
        written  += buffer.copy oldBuffer, 0, written, written + oldBuffer.length

        @_streamChunk.write oldBuffer
        @_streamChunk.end()

        @_createStreamChunk()

      lastBuffer = buffer.slice(written)
      @_streamChunk.write lastBuffer
      @_streamChunk.position = lastBuffer.length

    else if buffer.length + @_streamChunk.position == @chunkSize
      @_streamChunk.write buffer
      @_streamChunk.end()

      @_streamChunk = undefined

    else if buffer.length + @_streamChunk.position < @chunkSize
      @_streamChunk.write buffer
      @_streamChunk.position += buffer.length

  end: () ->
    @_streamChunk.end() if @_streamChunk
    @emit 'end'
    @writable = false

  destroy: () ->
    @_streamChunk.end() if @_streamChunk
    @emit 'end'
    @writable = false

