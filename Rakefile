task default: %w[run]

task :run do
  ruby "prisonphone.rb"
end

task :server do
  sh "docker run --rm -it -p 127.0.0.1:8088:8088/tcp -p 127.0.0.1:5060:5060/udp $(docker build -q .)"
end
