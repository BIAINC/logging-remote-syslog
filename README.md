# logging/remote-syslog

logging/remote-syslog is a remote syslog appender for use with the Logging library. ![Travis CI Status](https://secure.travis-ci.org/BIAINC/logging-remote-syslog.png)

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
:ident - [String] The identity of the sender
:syslog_server [String] - The syslog server
:strip_colors [True|False] - Some loggers like shell colors, should we remove them?
:facility [String] - Something like local6

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
