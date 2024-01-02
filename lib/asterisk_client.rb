# frozen_string_literal: true

require 'asterisk/ari/client'

# Asterisk client responsible for connecting to Asterisk and handling events
class AsteriskClient
  def initialize
    @@client = Ari::Client.new(
      url: 'http://127.0.0.1:8088/ari',
      api_key: 'asterisk:asterisk',
      app: 'prisonphone'
    )
    @@bridge = create_bridge_if_not_exists
  end

  def register_listener
    @@client.on :websocket_open do
      puts 'Connected !'
    end

    @@client.on :stasis_start do |e|
      AsteriskClient.handle_call(e)
    end

    @@client.connect_websocket
  end

  def create_bridge_if_not_exists
    bridge = @@client.bridges.list.select { |b| b.id == 'prisonphone' }.first
    bridge = @@client.bridges.create(type: 'mixing', bridgeId: 'prisonphone') if @bridge.nil?
    bridge
  end

  def start_moh
    @@bridge.start_moh
  end

  # class methods
  class << self
    def handle_call(e)
      puts "Received call to #{e.channel.dialplan.exten} !"

      e.channel.answer

      puts 'Adding call to bridge...'
      AsteriskClient.class_variable_get(:@@bridge).add_channel(channel: e.channel.id)

      register_channel_listener(e)
    end

    def register_channel_listener(e)
      e.channel.on :channel_dtmf_received do |e|
        puts "Digit pressed: #{e.digit} on channel #{e.channel.name} !"
      end

      e.channel.on :channel_destroyed do |e|
        puts "Channel #{e.channel.name} was destroyed."
      end

      e.channel.on :stasis_end do |e|
        puts "Channel #{e.channel.name} left Stasis."
      end
    end
  end
end
