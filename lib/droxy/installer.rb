module Droxy
  class Installer
    attr_reader :tld

    def initialize tld:, port: nil
      @tld, @port = tld, port
    end

    def port
      @port || raise("Port not specified")
    end

    def install
      ResolverFile.new(tld: tld).write port: port
      reload_network_configuration
    rescue Errno::EACCES
      raise SudoRequired
    end

    def uninstall
      ResolverFile.new(tld: tld).remove
      reload_network_configuration
    rescue Errno::EACCES
      raise SudoRequired
    end

private

    def reload_network_configuration
      location = `networksetup -getcurrentlocation`
      `networksetup -createlocation "droxy$$" >/dev/null 2>&1`
      `networksetup -switchtolocation "droxy$$" >/dev/null 2>&1`
      `networksetup -switchtolocation "#{location}" >/dev/null 2>&1`
      `networksetup -deletelocation "droxy$$" >/dev/null 2>&1`
    end
  end
end
