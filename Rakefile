# frozen_string_literal: true

docker_hub_path = 'docker.io/valtteri/inmatebridge'
trunk_args = '--trunkusername username --trunkpassword password --trunkhostnameandport 127.0.0.1:5060'
docker_flags = '--rm -p 127.0.0.1:4569:4569/udp -p 0.0.0.0:10000-10010:10000-10010/udp -p 0.0.0.0:5060:5060/udp'
dev_docker_flags = "#{docker_flags} -p 127.0.0.1:8088:8088/tcp"

task default: %w[run]

desc 'Run the prison phone'
task :run do
  sh "docker run -it #{docker_flags} $(docker build -q .) #{trunk_args}"
end

namespace :dev do
  desc 'Show help'
  task :help do
    ruby 'inmatebridge.rb --help'
  end

  desc 'Run InmateBridge locally without Asterisk'
  task :devclient do
    ruby 'inmatebridge.rb --devclient'
  end

  desc 'Run Asterisk without InmateBridge'
  task :devserver do
    sh "docker run #{dev_docker_flags} $(docker build -q .) #{trunk_args} --devserver"
  end

  desc 'Run tests'
  task :test do
    Dir.glob('test/*').select { |f| File.file? f }.each do |test_file|
      ruby "#{test_file}"
    end
  end

  desc 'Build docker image'
  task :build do
    sh "docker build . -t #{docker_hub_path}"
  end

  desc 'Push image to docker hub'
  task :push do
    sh "docker push #{docker_hub_path}"
  end
end
