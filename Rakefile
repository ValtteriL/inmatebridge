# frozen_string_literal: true

task default: %w[run]

desc 'Run the prison phone'
task :run do
  ruby 'prisonphone.rb'
end

desc 'Run Asterisk in Docker'
task :server do
  sh 'docker run --rm -it -p 127.0.0.1:8088:8088/tcp -p 127.0.0.1:4569:4569/udp $(docker build -q .)'
end
