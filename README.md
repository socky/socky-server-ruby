# Socky - server in Ruby [![](http://travis-ci.org/socky/socky-server-ruby.png)](http://travis-ci.org/socky/socky-server-ruby)

## Installation

    $ gem install socky-server --pre

## Usage

Socky server provides two Rack middlewares - WebSocket and HTTP. Each one of them can be used separately, but they can be also used in one process. Example Rackup file could look like that:

    require 'socky/server'
    
    map '/websocket' do
      run Socky::Server::WebSocket.new
    end
    
    map '/http' do
      run Socky::Server::HTTP.new
    end

## Configuration

Both middlewares accept options as hash. Currently available options are:

### :applications [Hash]

Hash of supported applications. Each key is application name, each value is application secret. You can use as much applications as you want - each of them will have separate application address created by mixing hostname, middleware address and applicatio name. So i.e. for app "my_app" WebSocket application uri will be:

    http://example.org/websocket/my_app

### :debug [Boolean]

Should application log output? Default Rack logger will be used, so demonized server will log to file. Please note that for HTTP middlewere Rack::CommonLogger will be more reliable that debug mode.

### :config [String]

Path to YAML config file. Config file should contain hash with exactly the same syntax like normal options.

## Example configuration

    require 'socky/server'

    options = {
      :debug => true,
      :applications => {
        :my_app => 'my_secret',
        :other_app => 'other_secret'
      }
    }

    map '/websocket' do
      run Socky::Server::WebSocket.new options
    end

    map '/http' do
      use Rack::CommonLogger
      run Socky::Server::HTTP.new options
    end

    $ thin -R config.ru -p3001 start

## Setting other options

Options like demonizing, logging to file, SSL support and others should be supported by Rack server like Thin. Socky Server is utilizing all of them so we will not describe them here.

## Which Rack servers are currently supported?

All that are supported by [websocket-rack](http://github.com/imanel/websocket-rack). At the time of writing only Thin was supported, but it should change in near future.

## License

(The MIT License)

Copyright (c) 2011 Bernard Potocki

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.