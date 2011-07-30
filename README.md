# Socky - server in Ruby [![](http://travis-ci.org/socky/socky-server-ruby.png)](http://travis-ci.org/socky/socky-server-ruby)

## Installation

``` bash
$ gem install socky-authenticator
```

## Usage

To use default config just run:

``` bash
$ thin -R config.ru start
```

You can also create your own rackup and config file to customize server.

## Which Rack servers are currently supported?

All that are supported by [websocket-rack](http://github.com/imanel/websocket-rack). At the time of writing only Thin was supported, but it should change in near future.

## License

(The MIT License)

Copyright (c) 2011 Bernard Potocki

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.