# frozen_string_literal: true

require 'optparse'
require './lib/argument'

# Parses command line arguments
class ArgParser
  attr_reader :collected_options, :parser

  def initialize
    @collected_options = Argument::DEFAULT_ARGUMENTS.dup
    @parser = OptionParser.new
    parser.on("--#{Argument::DEVSERVER}", 'Start Asterisk without InmateBridge')
    parser.on("--#{Argument::DEVCLIENT}", 'Start InmateBridge without Asterisk')
    parser.on("--#{Argument::TRUNK_USERNAME} [USERNAME]", 'SIP trunk username')
    parser.on("--#{Argument::TRUNK_PASSWORD} [PASSWORD]", 'SIP trunk password')
    parser.on("--#{Argument::TRUNK_HOSTNAME_AND_PORT} [HOSTNAME:PORT]", 'SIP trunk hostname:port')
    parser.on("--#{Argument::CALLERID} [CALLERID]",
              "CallerID number for trunk calls (default: #{Argument::DEFAULT_CALLERID})")
    parser.on("--#{Argument::USERNAME} [USERNAME]",
              "IAX2 username for inmates (default:#{Argument::DEFAULT_USERNAME})")
    parser.on("--#{Argument::PASSWORD} [PASSWORD]",
              "IAX2 password for inmates (default:#{Argument::DEFAULT_PASSWORD})")
  end

  def parse(options)
    parser.parse(options, into: collected_options)
    if (collected_options[Argument::TRUNK_USERNAME].nil? ||
      collected_options[Argument::TRUNK_PASSWORD].nil? ||
      collected_options[Argument::TRUNK_HOSTNAME_AND_PORT].nil?) &&
       !collected_options[Argument::DEVCLIENT]

      puts 'Missing trunk credentials and host information'
      exit 1
    end
    collected_options
  end
end
