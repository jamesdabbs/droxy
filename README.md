# Droxy

Like [pow](http://pow.cx/), but for [docker machines](https://docs.docker.com/machine/).

With `droxy` running, `dev.dock:3000` will resolve to `$(docker-machine ip dev):3000`.

__N.B. droxy uses /etc/resolver, and thus will likely only work on OSX__

## Installation

One-time setup:

    $ gem install droxy
    $ sudo droxy install

Droxy writes a [/etc/resolver](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/resolver.5.html) file, and thus needs sudo access to install.

Once droxy is installed, run the dns server with

    $ droxy start

You will, of course, need `docker-machine` installed and available.

# TODO

* Have installer write a plist file to auto-start on boot
* Some mechanism for showing errors (is the docker machine not running?)
* Better way to restart the network config after writing a resolver file?
* More Celluloid
  * Port to Celluloid::DNS once it's fully extracted
  * Make the ip (pre-)fetcher/cache an actor
