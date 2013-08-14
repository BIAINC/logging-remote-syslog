# Copyright (c) <2012> ['Tim Pease','Amy Sutedja', 'Paul Morton']
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

module Logging::Appenders
  def self.remote_syslog( *args )
    return Logging::Appenders::RemoteSyslog if args.empty?
    Logging::Appenders::RemoteSyslog.new(*args)
  end

  # This class provides an Appender that can write to remote syslog.
  #
  class RemoteSyslog < Logging::Appender
    # call-seq:
    #    RemoteSyslog.new( name, opts = {} )
    #
    # Create an appender that will log messages to remote syslog. The
    # options that can be used to configure the appender are as follows:
    #
    #    :ident         => identifier string (name is used by default)
    #    :syslog_server => address of the remote syslog server
    #    :port          => port of the remote syslog server
    #    :facility      => the syslog facility to use
    #    :modifier      => an optional callback method for altering original message; takes original message and returns updated one
    #
    # The parameter :ident is a string that will be prepended to every
    # message. The :facility parameter encodes a default facility to be
    # assigned to all messages that do not have an explicit facility encoded.
    #
    #    'auth'       The authorization system: login(1), su(1), getty(8),
    #                 etc.
    #
    #    'authpriv'   The same as 'auth', but logged to a file readable
    #                 only by selected individuals.
    #
    #    'cron'       The cron daemon: cron(8).
    #
    #    'daemon'     System daemons, such as routed(8), that are not
    #                 provided for explicitly by other facilities.
    #
    #    'ftp'        The file transfer protocol daemons: ftpd(8), tftpd(8).
    #
    #    'kern'       Messages generated by the kernel. These cannot be
    #                 generated by any user processes.
    #
    #    'lpr'        The line printer spooling system: lpr(1), lpc(8),
    #                 lpd(8), etc.
    #
    #    'mail'       The mail system.
    #
    #    'news'       The network news system.
    #
    #    'syslog'     Messages generated internally by syslogd(8).
    #
    #    'user'       Messages generated by random user processes. This is
    #                 the default facility identifier if none is specified.
    #
    #    'uucp'       The uucp system.
    #
    #    'local0'     Reserved for local use. Similarly for 'local1'
    #                 through 'local7'.
    #
    # See SyslogProtocol::FACILITIES for the complete list of valid values.
    #
    def initialize( name, opts = {} )
      @ident = opts.getopt(:ident, name)
      @syslog_server =  opts.getopt(:syslog_server, '127.0.0.1')
      @port = opts.getopt(:port, 514, :as => Integer)
      @modifier = opts.getopt(:modifier)

      @strip_colors =  opts.getopt(:strip_colors, true)

      facility_name = opts.getopt(:facility, 'user')

      @facility = ::SyslogProtocol::FACILITIES[facility_name]

      # provides a mapping from the default Logging levels
      # to the syslog levels
      @map = ['debug', 'info', 'warn', 'err', 'crit']

      map = opts.getopt(:map)
      self.map = map unless map.nil?

      super
    end

    # call-seq:
    #    map = { logging_levels => syslog_levels }
    #
    # Configure the mapping from the Logging levels to the syslog levels.
    # This is needed in order to log events at the proper syslog level.
    #
    # Without any configuration, the following mapping will be used:
    #
    #    :debug  =>  'debug'
    #    :info   =>  'info'
    #    :warn   =>  'warn'
    #    :error  =>  'err'
    #    :fatal  =>  'crit'
    #
    def map=( levels )
      map = []
      levels.keys.each do |lvl|
        num = ::Logging.level_num(lvl)
        map[num] = syslog_level_num(levels[lvl])
      end
      @map = map
    end

    def strip_ansi_colors(message)
      message.gsub /\e\[?.*?[\@-~]/, ''
    end

    def prepare_message(message)
      message = @strip_colors ? strip_ansi_colors(message) : message
      message = @modifier.call(message) if @modifier
      message
    end

    private

    # call-seq:
    #    write( event )
    #
    # Write the given _event_ to the syslog facility. The log event will be
    # processed through the Layout associated with this appender. The message
    # will be logged at the level specified by the event.
    #
    def write( event )
      pri = SyslogProtocol::SEVERITIES['debug']
      message = if event.instance_of?(::Logging::LogEvent)
          pri = @map[event.level]
          @layout.format(event)
        else
          event.to_s
        end
      return if message.empty?

      udp_sender = RemoteSyslogLogger::UdpSender.new(
        @syslog_server,
        @port,
        :facility => @facility,
        :severity => pri,
        :program => @ident
        )

      udp_sender.write(prepare_message(message))

      self
    end

    # call-seq:
    #    syslog_level_num( level )    => integer
    #
    # Takes the given _level_ as a string, symbol, or integer and returns
    # the corresponding syslog level number.
    #
    def syslog_level_num( level )
      case level
      when Integer; level
      when String, Symbol
        level = level.to_s.downcase
        SyslogProtocol::SEVERITIES[level]
      else
        raise ArgumentError, "unknown level '#{level}'"
      end
    end

  end  # RemoteSyslog
end # Logging::Appenders
