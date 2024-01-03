# frozen_string_literal: true

# User interface for the prison phone
class UI
  def initialize(asterisk_client)
    @client = asterisk_client
  end

  def nobody_connected_ui
    print_status 'Waiting for your call'
    puts 'Call XXX using SIP client'
  end

  def disconnect_call_ui
    print_status 'No call connected'

    puts 'Enter phone number to call'
    number = gets.chomp

    puts "Calling #{number}"
  end

  def run
    puts 'Available messages:'
    voicemessages = Dir.entries('sounds').select { |f| !File.directory? f }
    voicemessages.each_with_index do |message, index|
      puts "#{index}: #{message}"
    end

    puts 'Press m to toggle music on hold'
    puts 'Press q to disconnect call'

    puts '#############################################'

    while true
      input = fast_input

      if input.number?
        # puts "Playing message #{voicemessages[input.to_i]}"
        begin
          @client.toggle_sound voicemessages[input.to_i].split('.')[0]
        rescue NoMethodError
          nil
        end
      elsif input == 'm'
        @client.toggle_moh
      elsif input == 'q'
        puts 'Disconnecting call'
        break
      else
        puts "Invalid input \"#{input}\""
      end

    end
  end

  # class methods
  class << self
    def print_status(message)
      puts "[*] #{message}"
    end
  end

  private

  def print_menu
    puts 'Available messages:'
    voicemessages = Dir.entries('voicemessages').reject { |f| File.directory? f }
    voicemessages.each_with_index do |message, index|
      puts "#{index}: #{message}"
    end

    puts 'Press q to disconnect call'

    puts '#############################################'
  end

  def fast_input
    print 'prisonphone> '
    STDIN.getch
  end
end
