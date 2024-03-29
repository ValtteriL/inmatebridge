# frozen_string_literal: true

require 'pry'

# User interface for the prison phone
class UI
  attr_reader :client, :actions, :voicemessages

  def initialize(asterisk_client)
    @client = asterisk_client
    @actions = {
      'm' => @client.method(:toggle_moh),
      'h' => method(:print_menu),
      'c' => method(:call_ui),
      'x' => AsteriskClient.method(:hangup),
      "\r" => method(:puts),
      'l' => method(:list_bridge_participants)
    }
    @voicemessages = Dir.glob('sounds/**/*').select { |f| File.file? f }.map { |f| File.basename(f) }.sort
  end

  def run
    print_banner
    print_menu
    command_loop
  end

  # class methods
  class << self
    def print_status(message)
      puts "[*] #{message}"
    end
  end

  private

  def command_loop
    loop do
      input = fast_input

      if input.number?
        toggle_sound input.to_i
      elsif @actions.key? input
        @actions[input].call
      elsif input == 'q'
        puts 'Quitting'
        break
      else
        puts "Invalid input \"#{input}\". Press \"h\" for help."
      end
    end
  end

  def toggle_sound(index)
    puts "invalid sound selection: #{index}" if index >= voicemessages.length
    @client.toggle_sound voicemessages[index].split('.')[0]
  rescue NoMethodError
    nil
  end

  def print_banner
    puts '#############################################'
    puts '#                                           #'
    puts '#             Inmate Bridge                 #'
    puts '#                                           #'
    puts '#############################################'
  end

  def print_menu
    puts
    puts '#############################################'
    puts 'Controls:'
    puts 'h to show this menu'
    puts 'l to list bridge participants'
    puts 'm to toggle music on hold'
    puts 'c to call a victim'
    puts 'x to hangup victim'
    puts 'q to quit'
    puts

    puts 'Toggle sounds:'
    voicemessages.each_with_index do |message, index|
      puts "#{index}: #{message}"
    end

    puts '#############################################'
  end

  def prompt(*args)
    print(*args)
    STDIN.gets.chomp
  end

  def list_bridge_participants
    channels = client.list_channels
    if channels.any?
      puts
      puts 'Participants on bridge:'
      client.list_channels.map do |c|
        puts "- #{c.name} (victim)" if c.name.include? 'PJSIP'
        puts "- #{c.name}" unless c.name.include? 'PJSIP'
      end
    else
      puts 'Nobody connected to bridge'
    end
  end

  def fast_input
    print 'inmatebridge> '
    STDIN.getch
  end

  def call_ui
    number = prompt 'Enter phone number to call: '
    AsteriskClient.call number
  end
end
