# frozen_string_literal: true

require 'optparse'

# Parses command line arguments
class ArgParser
  attr_reader :collected_options, :parser

  def initialize
    @collected_options = { username: 'inmate', password: 'inmatebridge', dev: false }
    @parser = OptionParser.new
    parser.on('--dev', 'Start Asterisk without UI')
    parser.on('--sipstring STRING', 'SIP connection string for trunk (REQUIRED)')
    parser.on('--username [USERNAME]',
              "IAX2 username for inmates (default:#{collected_options[:username]})")
    parser.on('--password [PASSWORD]',
              "IAX2 password for inmates (default:#{collected_options[:password]})")
  end

  def parse(options)
    parser.parse(options, into: collected_options)
    if collected_options[:sipstring].nil?
      puts parser.help
      exit 1
    end
    collected_options
  end
end
