# logging/remote-syslog

logging/remote-syslog is a remote syslog appender for use with the [Logging](https://github.com/TwP/logging) library. ![Travis CI Status](https://secure.travis-ci.org/BIAINC/logging-remote-syslog.png)

## Installation

Add this line to your application's Gemfile:
    ```
    gem 'logging-remote-syslog', :require => 'logging/remote-syslog'
    ```

And then execute:
    ```
    $ bundle
    ```

Or install it yourself as:
    ```
    $ gem install logging-remote-syslog
    ```

## Options

    :ident - [String] Identity of the sender, such as a hostname or app ID
    :syslog_server [String] - Syslog server hostname or IP (default: `127.0.0.1`)
    :port [Integer] - Syslog server port (default: `514`)
    :strip_colors [True|False] - Some loggers like shell colors, should we remove them? (default: `True`)
    :facility [String] - A syslog facility name (default: `user`)
    :modifier [Method] - A callback for altering the original message (takes original message; returns modified one)

## Usage

```
require 'logging'
require 'logging/remote-syslog'

logger = Logging.logger['MyApp']
logger.add_appenders(
  Logging.appenders.remote_syslog(ident, syslog_server: syslog_host, port: syslog_port)
  )

logger.level = :info
logger.info 'MyApp Message'

```

Note that as shown above, a name is required as the first argument when
adding the appender. (If an `ident:` options hash key is also provided,
its value will be used as the sender instead of the name.)

## Example

This registers a new appender named after the system's hostname. It will
log to `logs.example.com:1111`.

```
require 'socket'
logger = Logging.logger['MyApp']
logger.add_appenders(
  Logging.appenders.remote_syslog(Socket.gethostname, syslog_server: 'logs.example.com', port: 1111)
  )
```

## Tests

```
rake
```

## Change Log
0.0.3 - Strip ANSI shell codes by default

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write code and add _tests_
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
