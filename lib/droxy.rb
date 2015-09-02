require "droxy/version"
require "droxy/error"
require "droxy/max_age_cache"
require "droxy/resolver_file"
require "droxy/dns_server"

require "open3"
require "uri"


module Droxy

  class Server
    attr_reader :tld

    def initialize tld:
      @tld      = tld
      @ip_cache = MaxAgeCache.new duration: 24 * 60 * 60

      @dns = DNSServer.new tld: tld, port: dns_port
    end

    def ip_for_name name
      @ip_cache.fetch(name) { query_ip name }
    end

    def query_ip name
      docker_machine "ip", name do |ip|
        return ip.empty? ? nil : ip
      end
    end

    def dns_port
      @_dns_port ||= ResolverFile.new(tld: tld).read_port
    end

    def run!
      prefetch_running_ips
      @dns.translate { |name| ip_for_name name }
    end

    def prefetch_running_ips
      docker_machine "ls" do |output|
        header, *machines = output.lines
        col = header =~ /URL\s/
        raise "Could not find URL in docker-machine output: #{output}" unless col
        machines.each do |line|
          name = line.split(/\s+/).first
          ip   = line[col..-1].split(/\s+/).first

          @ip_cache.fetch(name) { URI.parse(ip).host }
        end
      end
    end

private

    def docker_machine *args, &block
      Open3.popen3 "docker-machine", *args do |i,o,_,t|
        return unless t.value.success?
        block.call o.read.strip
      end
    end

  end
end
