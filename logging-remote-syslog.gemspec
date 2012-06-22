# -*- encoding: utf-8 -*-
# Copyright (c) <2012> ['Amy Sutedja', 'Paul Morton']
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this 
# software and associated documentation files (the "Software"), to deal in the Software 
# without restriction, including without limitation the rights to use, copy, modify, merge, 
# publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or 
# substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Gem::Specification.new do |gem|
  gem.authors       = ["Amy Sutedja", "Paul Morton"]
  gem.email         = ["asutedja@biaprotect.com", "pmorton@biaprotect.com"]
  gem.description   = "Remote syslog appender for Logging"
  gem.summary       = File.read('README.md')
  gem.homepage      = "https://github.com/BIAINC/logging-remote-syslog"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "logging-remote-syslog"
  gem.require_paths = ["lib"]
  gem.version       = File.read('./lib/logging/VERSION')
  gem.license       = 'MIT'

  gem.add_runtime_dependency 'logging', '>= 1.7.2'
  gem.add_runtime_dependency 'remote_syslog_logger', '>= 1.0.3'

  gem.add_development_dependency 'rspec', '>= 2.10.0'
  gem.add_development_dependency 'rake', '>= 0.9.2'
  gem.add_development_dependency 'rr', '>= 1.0.4'
end
