# frozen_string_literal: true

module Argument
  USERNAME = :username
  DEFAULT_USERNAME = 'inmate'

  PASSWORD = :password
  DEFAULT_PASSWORD = 'inmatebridge'

  CONNSTRING = :connstring
  DEFAULT_CONNSTRING = nil

  DEVSERVER = :devserver
  DEFAULT_DEVSERVER = false

  DEVCLIENT = :devclient
  DEFAULT_DEVCLIENT = false

  DEFAULT_ARGUMENTS = { Argument::USERNAME => Argument::DEFAULT_USERNAME,
                        Argument::PASSWORD => Argument::DEFAULT_PASSWORD,
                        Argument::DEVSERVER => Argument::DEFAULT_DEVSERVER,
                        Argument::DEVCLIENT => Argument::DEFAULT_DEVCLIENT,
                        Argument::CONNSTRING => Argument::DEFAULT_CONNSTRING }.freeze
end
