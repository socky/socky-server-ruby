Socky - server in Ruby
===========

Socky is push server for Ruby based on WebSockets. It allows you to break border between your application and client browser by letting the server initialize a connection and push data to the client.

## Example

You can try [live example](http://sockydemo.imanel.org) or view its [source code](http://github.com/socky/socky-example)

Also important information can be found on our [google group](http://groups.google.com/group/socky-users).

## Install

The best way to install Socky server is via RubyGems:

    gem install socky-server

Socky ruby server requires the gems em-websocket and em-http-request. These are automatically installed by the gem install command.

Alternative method is to clone repo and run it manually:

    git clone git://github.com/socky/socky-server-ruby.git
    cd socky-server-ruby
    ./bin/socky

You can also build it after clonning(this will require Jeweler gem)

    rake gemspec
    rake build

## Runtime Dependencies

- EM-WebSocket: Backend for WebSocket server
- EM-HTTP-Client: Sending authorize requests

## Usage

After installing gem you will have binary available:

    socky [OPTIONS]

First of all you will need to generate config file:

    socky -g config.yml

After that you can tweak this file, or just run server with default values:

    socky -c config.yml

## Configuration

The following is a list of the currently supported configuration options. These can all be specified by creating a config file. There are also flags for the `socky` executable which are described below next to their respective configuration options.

### Configuration Settings

| *Setting*       | *Config*                 | *Flag*                  | *Description* |
| --------------- | ------------------------ | ----------------------- | ------------- |
| Generate config |                          | `-g, --generate [path]` | Generate default config file
| Read config     |                          | `-c, --config [path]`   | Path to configuration file
| Port            | `port: [integer]`        | `-p, --port PORT`       | Set the port for server to listen
| Secure          | `secure: [boolean]`      | `-s, --secure`          | Set wss/SSL model on
| TLS Options     | `tls_options: [hash]`    |                         | Paths to private key file and certificate chain file for secure connection
| Daemon          | `daemon: [boolean]`      | `-d, --daemon`          | Run in daemon(background) mode
| Pid path        | `pid_path: [path]`       | `-P, --pid`             | Path to store pid path
| Kill            |                          | `-k, --kill`            | Kill daemonized server described by file in pid path
| Use log         | `log_path: [path]`       | `-l, --log [path]`      | Path to print debugging information
| Debug           | `debug: [boolean]`       | `--debug`               | Run in debug mode
| Deep debug      | `deep_debug: [boolean]`  | `--deep-debug`          | Run in debug mode that is even more verbose
| Subscribe URL   | `subscribe_url: [url]`   |                         | Url to with send authentication request
| Unsubscribe URL | `unsubscribe_url: [url]` |                         | Url to with send logout request
| Timeout         | `timeout: [integer]`     |                         | Time after with authentication request will timeout
| Secret          | `secret: [string]`       |                         | Key that will be used by to authorize as admin user

### Default Configuration

    :port: 8080
    :debug: false

    :subscribe_url: http://localhost:3000/socky/subscribe
    :unsubscribe_url: http://localhost:3000/socky/unsubscribe

    :secret: my_secret_key

    :secure: false

    # :timeout: 3

    # :log_path: /var/log/socky.log
    # :pid_path: /var/run/socky.pid

    # :tls_options:
    #   :private_key_file: /private/key
    #   :cert_chain_file: /ssl/certificate

## License

(The MIT License)

Copyright (c) 2010 Bernard Potocki

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.