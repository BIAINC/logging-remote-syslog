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

require 'spec_helper'

# Logging Logger
Logging.logger[::Logging].add_appenders(Logging.appenders.stdout)
Logging.logger[::Logging].level = :info

describe Logging::Appenders::RemoteSyslog do
  it 'can be instantiated' do
    Logging.appenders.remote_syslog('Test').should be_an_instance_of(Logging::Appenders::RemoteSyslog)
  end

  it 'can log' do
    syslog_host = 'logs.papertrailapp.com'
    syslog_port = 63961
    ident = 'Test'
    message = 'Test Message'
    level = :info
    facility = 'local6'

    any_instance_of(RemoteSyslogLogger::UdpSender) do |s|
      stub(s).initialize do |*args|
        args[0].should == syslog_host
        args[1].should == syslog_port
        args[2][:facility].should == SyslogProtocol::FACILITIES[facility]
        args[2][:severity].should == 'info'
        args[2][:program].should == ident
      end

      stub(s).write do |*args|
        args.first.should == " #{level.to_s.upcase}  #{ident} : #{message}\n"
      end
    end

    logger = Logging.logger['Test']
    logger.add_appenders(
      Logging.appenders.remote_syslog(ident, :syslog_server => syslog_host, :port => syslog_port, :facility => facility)
      )
    logger.level = level
    logger.info("Test Message").should == true
  end

  it 'strips shell codes by default' do
    appender = Logging.appenders.remote_syslog('Test', :syslog_server => '127.0.0.1', :facility => SyslogProtocol::FACILITIES['local6'])
    appender.prepare_message("\e[KTest Message\e[0m").should ==  'Test Message'
  end

  it 'should not strip shell code if asked' do
    appender = Logging.appenders.remote_syslog('Test', :syslog_server => '127.0.0.1', :facility => SyslogProtocol::FACILITIES['local6'], :strip_colors => false)
    appender.prepare_message("\e[KTest Message\e[0m").should ==  "\e[KTest Message\e[0m"
  end
end