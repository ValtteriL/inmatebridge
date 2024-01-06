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
    parser.on("--#{Argument::CONNSTRING} STRING", 'Connection string for trunk (REQUIRED)')
    parser.on("--#{Argument::USERNAME} [USERNAME]",
              "IAX2 username for inmates (default:#{Argument::DEFAULT_USERNAME})")
    parser.on("--#{Argument::PASSWORD} [PASSWORD]",
              "IAX2 password for inmates (default:#{Argument::DEFAULT_PASSWORD})")
  end

  def parse(options)
    parser.parse(options, into: collected_options)
    if collected_options[Argument::CONNSTRING].nil? && !collected_options[Argument::DEVSERVER]
      puts parser.help
      exit 1
    end
    collected_options
  end
end
