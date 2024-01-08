# frozen_string_literal: true

# AsteriskOperator patches config with IAX credentials and starts Asterisk
class AsteriskOperator
  def initialize(file, io, iax_username, iax_password, sip_username, sip_password, hostname_and_port, callerid)
    @file = file
    @io = io
    modify_iax_conf(iax_username, iax_password)
    modify_sip_wizard_conf(sip_username, sip_password, hostname_and_port)
    modify_dialplan(callerid)
  end

  def start
    io = @io.popen('asterisk -f')
    sleep 1 until io.gets.include? 'Asterisk Ready.'
    UI.print_status 'Asterisk ready'
    io
  end

  private

  def modify_sip_wizard_conf(username, password, hostname_and_port)
    replace_in_file '/etc/asterisk/pjsip_wizard.conf', { 'USERNAME' => username, 'PASSWORD' => password,
                                                         'REMOTE_HOST' => hostname_and_port }
  end

  def modify_iax_conf(username, password)
    replace_in_file '/etc/asterisk/iax.conf', { 'USERNAME' => username, 'PASSWORD' => password }
  end

  def modify_dialplan(callerid)
    replace_in_file('/etc/asterisk/extensions.conf', { 'INMATEBRIDGE_CALLERID' => callerid })
  end

  def replace_in_file(path, replacements)
    text = @file.read(path)
    replacements.each do |key, value|
      text.sub! key, value
    end
    @file.open(path, 'w') { |file| file << text }
  end
end
