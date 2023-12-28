require 'io/console'
require './lib/asterisk_client'


class UI
  def initialize
  end

  def nobody_connected_ui
    print_status "Waiting for your call"
    puts "Call XXX using SIP client"
  end

  def disconnect_call_ui
    print_status "No call connected"

    puts "Enter phone number to call"
    number = gets.chomp

    puts "Calling #{number}"
  end

  def during_call_ui
    print_status "Call connected"

    puts "Available messages:"
    voicemessages = Dir.entries("voicemessages").select {|f| !File.directory? f}
    voicemessages.each_with_index do |message, index|
      puts "#{index}: #{message}"
    end

    puts "Press q to disconnect call"

    puts "#############################################"

    while true
      input = get_input

      if input.is_number?
        puts "Playing message #{voicemessages[input.to_i]}"
      elsif input == 'q'
        puts "Disconnecting call"
        break
      else
        puts "Invalid input \"#{input}\""
      end

    end

  end

  private def print_status(message)
    puts "[*] " + message
  end

  private def get_input
    print "prisonphone> "
    return STDIN.getch
  end

end


class String
  def is_number?
    true if Float(self) rescue false
  end
end

client = AsteriskClient.new
client.run

ui = UI.new
#ui.nobody_connected_ui
#ui.disconnect_call_ui
ui.during_call_ui
