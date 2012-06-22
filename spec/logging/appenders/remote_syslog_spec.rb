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
        args.first.should == " #{level.upcase}  #{ident} : #{message}\n"
      end
    end

    logger = Logging.logger['Test']
    logger.add_appenders(
      Logging.appenders.remote_syslog(ident, syslog_server: syslog_host, port: syslog_port, facility: facility)
      )
    logger.level = level
    logger.info("Test Message").should == true
  end
end