Assert        = require 'assert'
StreamChunker = require '..'
test          = require 'utest'

test 'StreamChunker'
  'one write': () ->
    completeBuffer = ''
    chunkCount     = 0
    chunkData      = 0

    streamChunker = new StreamChunker
      chunkSize: 5

    streamChunker.on 'chunk', (chunk) ->
      chunkCount++

      switch chunkCount
        when 1
          Assert.equal chunk.streamPosition, 0
        when 2
          Assert.equal chunk.streamPosition, 5
        when 3
          Assert.equal chunk.streamPosition, 10

      chunk.on 'data', (buffer) ->
        chunkData++
        completeBuffer += buffer

        switch chunkData
          when 1
            Assert.equal chunkCount, 1
            Assert.equal buffer.length, 5
          when 2
            Assert.equal chunkCount, 2
            Assert.equal buffer.length, 5
          when 3
            Assert.equal chunkCount, 3
            Assert.equal buffer.length, 2

    streamChunker.on 'end' , () ->
      Assert.equal chunkCount, 3
      Assert.equal chunkData, 3
      Assert.equal '123456789012', completeBuffer

    streamChunker.write new Buffer '123456789012'
    streamChunker.end()

  'one write - destroy': () ->
    completeBuffer = ''
    chunkCount     = 0
    chunkData      = 0

    streamChunker = new StreamChunker
      chunkSize: 5

    streamChunker.on 'chunk', (chunk) ->
      chunkCount++

      switch chunkCount
        when 1
          Assert.equal chunk.streamPosition, 0
        when 2
          Assert.equal chunk.streamPosition, 5
        when 3
          Assert.equal chunk.streamPosition, 10

      chunk.on 'data', (buffer) ->
        chunkData++
        completeBuffer += buffer

        switch chunkData
          when 1
            Assert.equal chunkCount, 1
            Assert.equal buffer.length, 5
          when 2
            Assert.equal chunkCount, 2
            Assert.equal buffer.length, 5
          when 3
            Assert.equal chunkCount, 3
            Assert.equal buffer.length, 2

    streamChunker.on 'end' , () ->
      Assert.equal chunkCount, 3
      Assert.equal chunkData, 3
      Assert.equal '123456789012', completeBuffer

    streamChunker.write new Buffer '123456789012'
    streamChunker.destroy()

  'multiple writes': () ->
    completeBuffer = ''
    chunkCount     = 0
    chunkData      = 0

    streamChunker = new StreamChunker
      chunkSize: 5

    streamChunker.on 'chunk', (chunk) ->
      chunkCount++

      switch chunkCount
        when 1
          Assert.equal chunk.streamPosition, 0
        when 2
          Assert.equal chunk.streamPosition, 5
        when 3
          Assert.equal chunk.streamPosition, 10

      chunk.on 'data', (buffer) ->
        chunkData++
        completeBuffer += buffer

        switch chunkData
          when 1
            Assert.equal chunkCount, 1
            Assert.equal buffer.length, 5
          when 2
            Assert.equal chunkCount, 2
            Assert.equal buffer.length, 4
          when 3
            Assert.equal chunkCount, 2
            Assert.equal buffer.length, 1
          when 4
            Assert.equal chunkCount, 3
            Assert.equal buffer.length, 2

    streamChunker.on 'end' , () ->
      Assert.equal chunkCount, 3
      Assert.equal chunkData,  4
      Assert.equal '123456789012', completeBuffer

    streamChunker.write new Buffer '123456789'
    streamChunker.write new Buffer '012'
    streamChunker.end()

  'multiple writes - same length': () ->
    completeBuffer = ''
    chunkCount     = 0
    chunkData      = 0

    streamChunker = new StreamChunker
      chunkSize: 5

    streamChunker.on 'chunk', (chunk) ->
      chunkCount++

      switch chunkCount
        when 1
          Assert.equal chunk.streamPosition, 0
        when 2
          Assert.equal chunk.streamPosition, 5

      chunk.on 'data', (buffer) ->
        chunkData++
        completeBuffer += buffer

        switch chunkData
          when 1
            Assert.equal chunkCount, 1
            Assert.equal buffer.length, 5
          when 2
            Assert.equal chunkCount, 2
            Assert.equal buffer.length, 4
          when 3
            Assert.equal chunkCount, 2
            Assert.equal buffer.length, 1

    streamChunker.on 'end' , () ->
      Assert.equal chunkCount, 2, 'chunkCount'
      Assert.equal chunkData,  3, 'chunkData'
      Assert.equal '1234567890', completeBuffer

    streamChunker.write new Buffer '123456789'
    streamChunker.write new Buffer '0'
    streamChunker.end()

  'multiple writes with start position': () ->
    completeBuffer = ''
    chunkCount = 0
    chunkData = 0

    streamChunker = new StreamChunker
      chunkSize     : 5
      startPosition : 2

    streamChunker.on 'chunk', (chunk) ->
      chunkCount++

      switch chunkCount
        when 1
          Assert.equal chunk.streamPosition, 0
        when 2
          Assert.equal chunk.streamPosition, 5
        when 3
          Assert.equal chunk.streamPosition, 10

      chunk.on 'data', (buffer) ->
        chunkData++
        completeBuffer += buffer

        switch chunkData
          when 1
            Assert.equal chunkCount, 1
            Assert.equal buffer.length, 3
          when 2
            Assert.equal chunkCount, 2
            Assert.equal buffer.length, 4
          when 3
            Assert.equal chunkCount, 2
            Assert.equal buffer.length, 1
          when 4
            Assert.equal chunkCount, 3
            Assert.equal buffer.length, 1
          when 5
            Assert.equal chunkCount, 3
            Assert.equal buffer.length, 3

    streamChunker.on 'end' , () ->
      Assert.equal chunkCount, 3
      Assert.equal chunkData,  5
      Assert.equal '123456789012', completeBuffer

    streamChunker.write new Buffer '1234567'
    streamChunker.write new Buffer '89'
    streamChunker.write new Buffer '012'
    streamChunker.end()
