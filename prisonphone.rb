# frozen_string_literal: true

require 'io/console'
require './lib/asterisk_client'
require './lib/ui'
require './lib/string'

client = AsteriskClient.new
client.register_listener

ui = UI.new client
ui.run
