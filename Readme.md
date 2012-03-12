# node-streamchunker

[![Build Status](https://secure.travis-ci.org/Skomski/node-streamchunker.png?branch=master)](http://travis-ci.org/Skomski/node-streamchunker)

Break up streams into fixed-length streams

## Install

```
npm install streamchunker
```

## Usage

```javascript
var StreamChunker = require('streamchunker');

var streamChunker = new StreamChunker({
  chunkSize: 5
});

streamChunker.on('chunk', function(chunk) {
  chunk.on('data', function(buffer) {
  });
  chunk.on('end', function() {
  });
});

streamChunker.on('end' , function() {
});

buffer.pipe(streamChunker);
```

## License

Licensed under the MIT license.
