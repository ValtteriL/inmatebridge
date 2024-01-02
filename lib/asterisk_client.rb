# frozen_string_literal: true

require 'asterisk/ari/client'
require 'pry'

# Asterisk client responsible for connecting to Asterisk and handling events
class AsteriskClient
  def initialize
    @@client = Ari::Client.new(
      url: 'http://127.0.0.1:8088/ari',
      api_key: 'asterisk:asterisk',
      app: 'prisonphone'
    )
    @@bridge = create_bridge_if_not_exists
    @moh_playing = false

    register_listener
  end

  def register_listener
    @@client.on :websocket_open do
      UI.print_status 'InmateBridge ready'
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

  def toggle_moh
    if @moh_playing
      UI.print_status 'Stopping MOH'
      @@bridge.stop_moh
    else
      UI.print_status 'Starting MOH'
      @@bridge.start_moh
    end
    @moh_playing = !@moh_playing
  end

  def toggle_sound(filename)
    playback = begin
      @@client.playbacks.get(playbackId: filename)
    rescue StandardError
      nil
    end

    if playback.nil?
      UI.print_status "Playing #{filename}"
      @@bridge.play_with_id(playbackId: filename, media: "sound:#{filename}")
    else
      UI.print_status "Stopping #{filename}"
      @@client.playbacks.stop(playbackId: filename)
    end
  end

  # class methods
  class << self
    def play_sound_in_bridge(filename)
      AsteriskClient.class_variable_get(:@@bridge).play(media: "sound:#{filename}")
    end

    def handle_call(e)
      e.channel.answer

      bridge = AsteriskClient.class_variable_get(:@@bridge)
      bridge.add_channel(channel: e.channel.id)
      UI.print_status "Inmate #{e.channel.name} joined bridge"
      AsteriskClient.play_sound_in_bridge('confbridge-join')

      register_channel_listener(e)
    end

    def register_channel_listener(e)
      e.channel.on :channel_dtmf_received do |e|
        UI.print_status "Inmate #{e.channel.name} pressed: #{e.digit}"
      end

      e.channel.on :stasis_end do |e|
        UI.print_status "Inmate #{e.channel.name} disconnected"
        AsteriskClient.play_sound_in_bridge('confbridge-leave')
      end
    end
  end
end
