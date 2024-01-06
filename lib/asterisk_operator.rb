# frozen_string_literal: true

# AsteriskOperator patches config with IAX credentials and starts Asterisk
class AsteriskOperator
  def initialize(file, io, iax_username, iax_password, sip_username, sip_password, hostname_and_port)
    @file = file
    @io = io
    modify_iax_conf(iax_username, iax_password)
    modify_sip_wizard_conf(sip_username, sip_password, hostname_and_port)
  end

  def start
    io = @io.popen('asterisk -f')
    sleep 1 until io.gets.include? 'Asterisk Ready.'
    UI.print_status 'Asterisk ready'
    io
  end

  private

  def modify_sip_wizard_conf(username, password, hostname_and_port)
    filepath = '/etc/asterisk/pjsip_wizard.conf'
    text = @file.read(filepath)
    text.sub! 'USERNAME', username
    text.sub! 'PASSWORD', password
    text.sub! 'REMOTE_HOST', hostname_and_port
    @file.open(filepath, 'w') { |file| file << text }
  end

  def modify_iax_conf(username, password)
    filepath = '/etc/asterisk/iax.conf'
    text = @file.read(filepath)
    text.sub! 'USERNAME', username
    text.sub! 'PASSWORD', password
    @file.open(filepath, 'w') { |file| file << text }
  end
end
