# frozen_string_literal: true

# AsteriskOperator patches config with IAX credentials and starts Asterisk
class AsteriskOperator
  def initialize(username, password)
    modify_config username, password
  end

  def start
    io = IO.popen('asterisk -f')
    sleep 1 until io.gets.include? 'Asterisk Ready.'
    UI.print_status 'Asterisk ready'
    io
  end

  private

  def modify_config(username, password)
    text = File.read('/etc/asterisk/iax.conf')
    text.sub! 'USERNAME', username
    text.sub! 'PASSWORD', password
    File.open('/etc/asterisk/iax.conf', 'w') { |file| file << text }
  end
end
