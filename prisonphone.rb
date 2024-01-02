# frozen_string_literal: true

require 'io/console'
require './lib/asterisk_client'
require './lib/ui'
require './lib/string'

client = AsteriskClient.new

ui = UI.new client
ui.run
