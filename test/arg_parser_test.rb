# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/arg_parser'

class ArgParserTest < Minitest::Test
  def setup
    @arg_parser = ArgParser.new
  end

  def test_parse_setting_trunk_credentials
    trunk_username = 'username'
    trunk_password = 'password'
    trunk_hostname_and_port = 'somehost:1234'

    assert_equal(
      {
        Argument::DEVCLIENT => Argument::DEFAULT_DEVCLIENT, Argument::DEVSERVER => Argument::DEFAULT_DEVSERVER,
        Argument::USERNAME => Argument::DEFAULT_USERNAME, Argument::PASSWORD => Argument::DEFAULT_PASSWORD,
        Argument::CALLERID => Argument::DEFAULT_CALLERID,
        Argument::TRUNK_USERNAME => trunk_username, Argument::TRUNK_PASSWORD => trunk_password,
        Argument::TRUNK_HOSTNAME_AND_PORT => trunk_hostname_and_port
      },
      @arg_parser.parse(["--#{Argument::TRUNK_USERNAME}", trunk_username, "--#{Argument::TRUNK_PASSWORD}", trunk_password,
                         "--#{Argument::TRUNK_HOSTNAME_AND_PORT}", trunk_hostname_and_port])
    )
  end

  def test_parse_requires_trunk_credentials_on_devserver
    assert_raises(SystemExit) do
      @arg_parser.parse(%w[--devserver])
    end
  end

  def test_parse_setting_devclient
    assert_equal(@arg_parser.parse(%w[--devclient])[Argument::DEVCLIENT], true)
  end

  def test_parse_setting_devserver
    assert_equal(
      @arg_parser.parse(%w[--devserver --trunkusername a --trunkpassword a --trunkhostnameandport
                           a])[Argument::DEVSERVER], true
    )
  end

  def test_setting_iax_credentials
    username = 'username'
    password = 'password'
    assert_equal(
      @arg_parser.parse(["--#{Argument::USERNAME}", username, "--#{Argument::PASSWORD}", password,
                         "--#{Argument::DEVCLIENT}"]),
      {
        Argument::DEVCLIENT => true, Argument::DEVSERVER => Argument::DEFAULT_DEVSERVER,
        Argument::USERNAME => username, Argument::PASSWORD => password,
        Argument::CALLERID => Argument::DEFAULT_CALLERID,
        Argument::TRUNK_USERNAME => Argument::DEFAULT_TRUNK_USERNAME,
        Argument::TRUNK_PASSWORD => Argument::DEFAULT_TRUNK_PASSWORD,
        Argument::TRUNK_HOSTNAME_AND_PORT => Argument::DEFAULT_TRUNK_HOSTNAME_AND_PORT
      }
    )
  end
end
