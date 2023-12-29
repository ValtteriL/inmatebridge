require 'asterisk/ari/client'

class AsteriskClient
  def initialize
    @client = Ari::Client.new(
      url: 'http://127.0.0.1:8088/ari',
      api_key: 'asterisk:asterisk',
      app: 'hello-world'
    )
  end

  def asdasdas
    puts 'kek'
  end

  def run
    # listen to events
    @client.on :websocket_open do
      puts 'Connected !'
    end

    @client.on :stasis_start do |e|
      puts "Received call to #{e.channel.dialplan.exten} !"

      e.channel.answer

      e.channel.on :channel_dtmf_received do |e|
        puts "Digit pressed: #{e.digit} on channel #{e.channel.name} !"
      end

      e.channel.on :stasis_end do |e|
        puts "Channel #{e.channel.name} left Stasis."
      end
    end

    # start websocket to receive events
    @client.connect_websocket
    sleep
  end

  def call(_number)
    raise 'Not implemented'
    # originate
    # @client.channels.originate endpoint: 'PJSIP/endpoint-name', extension: 11
  end

  def get_channels
    @client.channels.list
  end
end
