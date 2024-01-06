FROM ruby:3.3.0-bullseye
LABEL maintainer="Valtteri Lehtinen <Valtteri@shufflingbytes.com>"
LABEL org.opencontainers.image.source https://github.com/ValtteriL/inmatebridge

ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update && apt-get install -y \
    asterisk

# add asterisk config
COPY config/ /etc/asterisk/

# add sounds
COPY sounds/ /usr/share/asterisk/sounds/

# copy inmatebridge binary
COPY . /inmatebridge
WORKDIR /inmatebridge
RUN bundle install

# entrypoint
ENTRYPOINT ["bundle", "exec", "ruby", "inmatebridge.rb"]
