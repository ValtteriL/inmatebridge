# frozen_string_literal: true

require 'asterisk/ari/client'
require './lib/callback_handler'
require './lib/asterisk_constants'
require 'pry'

# Asterisk client responsible for connecting to Asterisk and handling events
class AsteriskClient
  def initialize
    Ari.client = Ari::Client.new(
      url: 'http://127.0.0.1:8088/ari',
      api_key: 'asterisk:asterisk',
      app: AsteriskConstants::APP_ID
    )

    @@bridge = create_bridge_if_not_exists
    @moh_playing = false

    register_listener
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

  def list_channels
    Ari.client.channels.list
  end

  private

  def register_listener
    Ari.client.on :websocket_open do
      UI.print_status 'InmateBridge ready'
    end

    Ari.client.on :stasis_start do |e|
      CallbackHandler.handle_call(e)
    end

    Ari.client.connect_websocket
  end

  def create_bridge_if_not_exists
    bridge = Ari.client.bridges.list.select { |b| b.id == AsteriskConstants::BRIDGE_ID }.first
    bridge = Ari.client.bridges.create(type: 'mixing', bridgeId: AsteriskConstants::BRIDGE_ID) if @bridge.nil?
    bridge
  end

  # class methods
  class << self
    def call(number)
      UI.print_status "Calling #{number}"
      AsteriskClient.play_sound_in_bridge('calling')

      begin
        Ari.client.channels.originate_with_id(endpoint: "PJSIP/#{number}@trunk", app: AsteriskConstants::APP_ID,
                                              channelId: AsteriskConstants::VICTIM_ID)
      rescue StandardError => e
        UI.print_status "Error calling #{number}: #{e}"
      end
    end

    def hangup
      UI.print_status 'Hanging up victim'
      begin
        Ari.client.channels.hangup(channelId: AsteriskConstants::VICTIM_ID)
      rescue StandardError
        nil
      end
    end

    def currently_playing_playback
      Ari.client.playbacks.get(playbackId: AsteriskConstants::PLAYBACK_ID)
    rescue StandardError
      nil
    end

    def stop_sound_in_bridge
      Ari.client.playbacks.stop(playbackId: AsteriskConstants::PLAYBACK_ID)
    rescue StandardError
      nil
    end

    def play_sound_in_bridge(filename)
      class_variable_get(:@@bridge).play_with_id(playbackId: AsteriskConstants::PLAYBACK_ID, media: "sound:#{filename}")
    end
  end
end
