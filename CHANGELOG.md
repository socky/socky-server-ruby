# Changelog

## 0.4.0 / 2010-10-27

- new features:
  - rename project to 'socky-server-ruby' for future compatibility
- bugfixes:
  - use fund_all in finders instead of collect in finders

## 0.2.1 / 2010-10-09

- new features:
  - default config should have subscribe url's commented out for starting users
- bugfixes:
  - show sent messages in true form instead of "inspect" one

## 0.2.0 / 2010-10-03

- new features:
  - inline documentation
- bugfixes:
  - send authentication after finishing handshake
  - tests less using stubs and more real cases
  - fix some tests

## 0.1.3 / 2010-09-23

- new features:
  - none
- bugfixes:
  - fix query :show_connections in ruby 1.9
  - fix user authentication when url subscribe/unsubscribe is disabled

## 0.1.2 / 2010-09-21

- new features:
  - none
- bugfixes:
  - fix routes to spec_helper in ruby 1.9.2
  - ruby 1.9 will no longer raise errors on String to_a call

## 0.1.1 / 2010-08-25

- new features:
  - socky has now support for signed certificates by :tls_options config option
- bugfixes:
  - none

## 0.1.0 / 2010-08-03

**IMPORTANT! This version will not work with plugin version lower than 0.1.0**

- new features:
  - server now send authentication status
  - new syntax
  - option to exclude clients/channels
- bugfixes:
  - none

## 0.0.9 / 2010-06-20

**IMPORTANT! This version will not work with plugin version lower than 0.0.9**

- new features:
  - support for next version of em-websocket debug options(based on mloughran branch)
  - support for websocket draft 76
  - support for wss/SSL connections
  - socky can now be started in 'daemon' mode
  - socky now sending all messages in JSON format
- bugfixes:
  - socky will no longer crash when when request query is invalid - i.e. chrome 6.0.*(with websocket draft76) and em-websocket 0.0.6

## 0.0.8 / 2010-06-06

- new features:
  - full rspec suite
  - allow admin param to be both "1" and "true"
- bugfixes:
  - proper configuration options parsing order
  - rescue from invalid config file
  - rescue from invalid args
  - symbolize_keys will no longer raise error if argument is not hash
  - modules will no longer depend on parent class
  - message will no longer raise exeption is JSON is invalid

## 0.0.7 / 2010-05-25

- new features:
  - user authentication is now async
- bugfixes:
  - server will no longer fail when starting from source instead of gem

## 0.0.6 / 2010-05-24

- initial release