# frozen_string_literal: true

require 'io/console'
require './lib/arg_parser'
require './lib/asterisk_client'
require './lib/ui'
require './lib/string'
require 'pry'

arg_parser = ArgParser.new
options = arg_parser.parse ARGV

client = AsteriskClient.new

ui = UI.new client
ui.run
