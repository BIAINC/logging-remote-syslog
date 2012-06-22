# -*- encoding: utf-8 -*-
require File.expand_path('../lib/logging/remote-syslog/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Amy Sutedja"]
  gem.email         = ["asutedja@biaprotect.com"]
  gem.description   = "Remote syslog appender for Logging"
  gem.summary       = "Remote syslog appender for Logging"
  gem.homepage      = "https://github.com/BIAINC/logging-remote-syslog"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "logging-remote-syslog"
  gem.require_paths = ["lib"]
  gem.version       = Logging::RemoteSyslog::VERSION

  gem.add_runtime_dependency('logging', ['>= 1.7.2'])
  gem.add_runtime_dependency('remote_syslog_logger', ['>= 1.0.3'])
  gem.add_development_dependency('rspec', ['>= 2.10.0'])
  gem.add_development_dependency('rake', ['>= 0.9.2'])
  gem.add_development_dependency('rr', ['>= 1.0.4'])
end
