require "rubydns"

module Droxy
  class DNSServer
    IN = Resolv::DNS::Resource::IN

    attr_reader :tld, :port

    def initialize tld:, port:
      @tld, @port = tld, port
    end

    def interfaces
      [ [:udp, "0.0.0.0", port], [:tcp, "0.0.0.0", port] ]
    end

    def translate &block
      srv = self # yay, metaprogramming
      RubyDNS.run_server listen: interfaces do
        logger.level = Logger::INFO

        match /(\w+)\.#{srv.tld}/, IN::AAAA do
          next!
        end

        match /(\w+)\.#{srv.tld}/, IN::A do |transaction, capture|
          if ip = block.call(capture[1])
            transaction.respond! ip
          else
            next!
          end
        end

        otherwise { |transaction| transaction.passthrough! srv.fallback_dns }
      end
    end

    def fallback_dns
      @_fallback_dns ||= RubyDNS::Resolver.new([ [:udp, "8.8.8.8", 53], [:tcp, "8.8.8.8", 53] ])
    end

  end
end
