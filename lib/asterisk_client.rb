# frozen_string_literal: true

require 'asterisk/ari/client'
require 'pry'

# Asterisk client responsible for connecting to Asterisk and handling events
class AsteriskClient
  attr_reader :client, :bridge

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
    # stop playbacks
    # if requested one was not playing, start it

    playback = AsteriskClient.currently_playing_playback
    AsteriskClient.stop_sound_in_bridge

    if playback.nil? || playback.media_uri != "sound:#{filename}"
      UI.print_status "Playing #{filename}"
      AsteriskClient.play_sound_in_bridge filename
    else
      UI.print_status "Stopping #{filename}"
    end
  end

  # class methods
  class << self
    PLAYBACK_ID = 'prisonphone'

    def currently_playing_playback
      @@client.playbacks.get(playbackId: PLAYBACK_ID)
    rescue StandardError
      nil
    end

    def stop_sound_in_bridge
      class_variable_get(:@@client).playbacks.stop(playbackId: PLAYBACK_ID)
    rescue StandardError
      nil
    end

    def play_sound_in_bridge(filename)
      class_variable_get(:@@bridge).play_with_id(playbackId: PLAYBACK_ID, media: "sound:#{filename}")
    end

    def handle_call(e)
      e.channel.answer

      bridge = class_variable_get(:@@bridge)
      bridge.add_channel(channel: e.channel.id)
      UI.print_status "Inmate #{e.channel.name} joined bridge"
      play_sound_in_bridge('confbridge-join')

      register_channel_listener(e)
    end

    def register_channel_listener(e)
      e.channel.on :channel_dtmf_received do |e|
        UI.print_status "Inmate #{e.channel.name} pressed: #{e.digit}"
      end

      e.channel.on :stasis_end do |e|
        UI.print_status "Inmate #{e.channel.name} disconnected"
        play_sound_in_bridge('confbridge-leave')
      end
    end
  end
end
