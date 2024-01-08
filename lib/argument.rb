# frozen_string_literal: true

module Argument
  USERNAME = :username
  DEFAULT_USERNAME = 'inmate'

  PASSWORD = :password
  DEFAULT_PASSWORD = 'inmatebridge'

  CALLERID = :callerid
  DEFAULT_CALLERID = '0123456789'

  TRUNK_USERNAME = :trunkusername
  DEFAULT_TRUNK_USERNAME = nil

  TRUNK_PASSWORD = :trunkpassword
  DEFAULT_TRUNK_PASSWORD = nil

  TRUNK_HOSTNAME_AND_PORT = :trunkhostnameandport
  DEFAULT_TRUNK_HOSTNAME_AND_PORT = nil

  DEVSERVER = :devserver
  DEFAULT_DEVSERVER = false

  DEVCLIENT = :devclient
  DEFAULT_DEVCLIENT = false

  DEFAULT_ARGUMENTS = { Argument::USERNAME => Argument::DEFAULT_USERNAME,
                        Argument::PASSWORD => Argument::DEFAULT_PASSWORD,
                        Argument::DEVSERVER => Argument::DEFAULT_DEVSERVER,
                        Argument::DEVCLIENT => Argument::DEFAULT_DEVCLIENT,
                        Argument::CALLERID => Argument::DEFAULT_CALLERID,
                        Argument::TRUNK_USERNAME => Argument::DEFAULT_TRUNK_USERNAME,
                        Argument::TRUNK_PASSWORD => Argument::DEFAULT_TRUNK_PASSWORD,
                        Argument::TRUNK_HOSTNAME_AND_PORT => Argument::DEFAULT_TRUNK_HOSTNAME_AND_PORT }.freeze
end
