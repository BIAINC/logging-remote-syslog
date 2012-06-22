# logging/remote-syslog

logging/remote-syslog is a remote syslog appender for use with the Logging library.

## Installation

Add this line to your application's Gemfile:

    ```bash
    gem 'logging-remote-syslog'
    ```

And then execute:
    ```bash
    $ bundle
    ```

Or install it yourself as:
    ```bash
    $ gem install logging-remote-syslog
    ```

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write code and add _tests_
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
