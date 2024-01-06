# frozen_string_literal: true

connstring = 'sip:inmate:inmatebridge@trunk'
docker_flags = '--rm -p 127.0.0.1:8088:8088/tcp -p 127.0.0.1:4569:4569/udp'

task default: %w[run]

desc 'Run the prison phone'
task :run do
  ruby "inmatebridge.rb --connstring #{connstring} --devclient"
end

namespace :dev do
  desc 'Run InmateBridge without Asterisk'
  task :devclient do
    ruby "inmatebridge.rb --connstring #{connstring} --devclient"
  end

  desc 'Run Asterisk without InmateBridge'
  task :devserver do
    sh "docker run #{docker_flags} $(docker build -q .) --devserver"
  end
end
