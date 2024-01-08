# frozen_string_literal: true

# CallbackHandler is responsible for handling callbacks from Asterisk client
class CallbackHandler
  class << self
    def handle_call(e)
      e.channel.answer
      AsteriskClient.play_sound_in_bridge('confbridge-join')

      # dont let victim hear sound
      sleep 1 if e.channel.name.include? 'Local'

      bridge = AsteriskClient.class_variable_get(:@@bridge)
      bridge.add_channel(channel: e.channel.id)
      UI.print_status "#{e.channel.name} joined bridge"

      CallbackHandler.register_channel_listener(e)
    end

    def register_channel_listener(e)
      e.channel.on :channel_dtmf_received do |e|
        UI.print_status "#{e.channel.name} pressed: #{e.digit}"
      end

      e.channel.on :stasis_end do |e|
        UI.print_status "#{e.channel.name} disconnected"
        AsteriskClient.play_sound_in_bridge('confbridge-leave')
      end
    end
  end
end
