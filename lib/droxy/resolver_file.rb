module Droxy
  class ResolverFile
    attr_reader :tld

    def initialize tld:
      @tld = tld
    end

    def path
      "/etc/resolver/#{tld}"
    end

    def write port:
      File.write path, <<-EOF
nameserver 127.0.0.1
port #{port}
      EOF
    end

    def remove
      FileUtils.rm path
    end

    def read_port
      @_read_port ||= File.read(path) =~ /^port (\d+)/ && Integer($1)
    end
  end
end
