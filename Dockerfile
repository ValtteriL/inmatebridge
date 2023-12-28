FROM ubuntu:jammy-20231211.1

ARG DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt-get update && apt-get install -y \
    bash \
    ruby-full \
    asterisk


# add asterisk config
COPY config/ /etc/asterisk/

# entrypoint
CMD [ "asterisk", "-f" ]