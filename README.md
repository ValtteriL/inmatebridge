# InmateBridge

InmateBridge is a VoIP voice bridge with a soundboard. It lets you make calls over SIP to talk and play sounds at people.

The purpose is prank calling. InmateBridge is inspired by [Phone Losers of America](https://phonelosers.com/) prank call show and includes my favorite sound effects played on it.

Writeup [here](https://shufflingbytes.com/posts/voip-voice-bridge-with-soundboard-for-prank-calling/).

## Description

The InmateBridge container starts Asterisk PBX in the background and a console application to operate the PBX.
You call into the Asterisk using IAX2. Your friends may call in as well.
You then use the CLI to call victims over SIP, play sounds, etc.

![High-level architecture of InmateBridge](/images/inmatebridge-implementation.png)

### Prerequisites

To get fun out of InmateBridge, you need the following

1. An IAX2 (soft)phone (such as [Zoiper](https://www.zoiper.com/))
2. A SIP trunk

## Demo

[![asciicast](https://asciinema.org/a/630473.svg)](https://asciinema.org/a/630473)

## Usage

1. Start InmateBridge.
2. After you see the console UI, register your phone to the PBX (IAX2 endpoint is listening at 127.0.0.1:4569).
3. Call any number with 2 or more digits on your IAX2 phone to be added to the voice bridge.
4. Test playing sounds at yourself and get comfortable with the UI.
5. Follow the UI to call your first victim.

InmateBridge Usage:

```text
Usage: inmatebridge [options]
        --devserver                  Start Asterisk without InmateBridge
        --devclient                  Start InmateBridge without Asterisk
        --trunkusername [USERNAME]   SIP trunk username
        --trunkpassword [PASSWORD]   SIP trunk password
        --trunkhostnameandport [HOSTNAME:PORT]
                                     SIP trunk hostname:port
        --callerid [CALLERID]        CallerID number for trunk calls (default: 0123456789)
        --username [USERNAME]        IAX2 username for inmates (default:inmate)
        --password [PASSWORD]        IAX2 password for inmates (default:inmatebridge)
```

```bash
docker run -it --rm valtteri/inmatebridge --help
```

Example:

```bash
docker run -it --rm -p 127.0.0.1:4569:4569/udp -p 0.0.0.0:10000-10010:10000-10010/udp -p 0.0.0.0:5060:5060/udp valtteri/inmatebridge --trunkusername username --trunkpassword password --trunkhostnameandport 192.168.0.1:5060
```

To include your own sounds effects in the soundboard, mount them to /usr/share/asterisk/sounds/custom and to /inmatebridge/sounds/custom
```bash
docker run .... -v <dir-with-your-sounds>:/usr/share/asterisk/sounds/custom -v <dir-with-your-sounds>:/inmatebridge/sounds/custom
```
Note: the sounds should be signed linear 16 bit 8kHz mono in .wav format

### Usage for development

Start development server:

```bash
bundle exec rake devserver
```

Start client:

```bash
bundle exec rake devclient
```

Help:

```bash
bundle exec rake -T
```

### Debugging

If calls to victims dont succeed, open Asterisk CLI in the container, enable logging, and try calling again
This may reveal for example requirements with caller ID set by the trunk in use

```bash
# enter running container
docker exec -it <container id/name> bash

# once inside, open asterisk CLI
asterisk -r

# on asterisk CLI, enable pjsip logging
pjsip set logging on
pjsip set logging verbose on

# keep the CLI open while you try calling again to see in detail the messaging
```
