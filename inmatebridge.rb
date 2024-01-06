# frozen_string_literal: true

require 'io/console'
require './lib/arg_parser'
require './lib/asterisk_client'
require './lib/asterisk_operator'
require './lib/ui'
require './lib/string'
require 'pry'

arg_parser = ArgParser.new
options = arg_parser.parse ARGV

if options[Argument::DEVCLIENT]
  UI.print_status 'Starting InmateBridge without Asterisk'
  UI.new(AsteriskClient.new).run
  exit 0
elsif options[Argument::DEVSERVER]
  UI.print_status 'Starting Asterisk without InmateBridge'
  io = AsteriskOperator.new(options[Argument::USERNAME], options[Argument::PASSWORD]).start

  while (line = io.gets)
    puts line
  end

  exit 0
end

UI.print_status 'Starting InmateBridge'

AsteriskOperator.new(options[Argument::USERNAME], options[Argument::PASSWORD]).start
UI.new(AsteriskClient.new).run
