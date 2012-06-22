Dir['./spec/support/**/*.rb'].map {|f| require f}

require 'logging'
require 'logging/remote-syslog'
