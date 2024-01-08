require 'minitest/autorun'
require_relative '../lib/asterisk_operator'
require_relative '../lib/ui'

class AsteriskOperatorTest < Minitest::Test
  def setup
    @username = 'username'
    @password = 'password'
    @hostname_and_port = 'hostname_and_port'
    @sip_username = 'sip_username'
    @sip_password = 'sip_password'
    @callerid = 'callerid'
  end

  def test_initialize_and_start
    mock_io = Minitest::Mock.new
    mock_io.expect :popen, mock_io, ['asterisk -f']
    mock_io.expect :gets, 'Asterisk Ready.'

    mock_file = Minitest::Mock.new
    mock_file.expect :read, 'asd', ['/etc/asterisk/iax.conf']
    mock_file.expect :open, nil, ['/etc/asterisk/iax.conf', 'w']
    mock_file.expect :read, 'asd', ['/etc/asterisk/pjsip_wizard.conf']
    mock_file.expect :open, nil, ['/etc/asterisk/pjsip_wizard.conf', 'w']
    mock_file.expect :read, 'asd', ['/etc/asterisk/extensions.conf']
    mock_file.expect :open, nil, ['/etc/asterisk/extensions.conf', 'w']

    operator = AsteriskOperator.new(mock_file, mock_io, @username, @password, @sip_username, @sip_password,
                                    @hostname_and_port, @callerid)

    result = operator.start

    assert_mock mock_io
  end
end
