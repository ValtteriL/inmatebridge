# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/asterisk_client'
require_relative '../lib/ui'

class Testbridge
  def list
    []
  end

  def create(options = {}); end
end

class AsteriskClientTest < Minitest::Test
  def test_initialize_toggle_moh
    # dummy responses for Ari::Client
    mock = Minitest::Mock.new
    mock.expect :bridges, Testbridge.new
    mock.expect :bridges, Testbridge.new
    mock.expect :on, true, [:websocket_open]
    mock.expect :on, true, [:stasis_start]
    mock.expect :connect_websocket, true

    Ari::Client.stub :new, mock do
      client = AsteriskClient.new
      assert_equal client.instance_variable_get(:@moh_playing), false
    end

    assert_mock mock
  end
end
