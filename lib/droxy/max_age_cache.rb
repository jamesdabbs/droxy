module Droxy
  class MaxAgeCache
    Entry = Struct.new :value, :created

    attr_reader :duration

    def initialize duration:
      @duration, @store = duration, {}
    end

    def fetch key, &block
      unless acceptable? @store[key]
        @store[key] = Entry.new block.call, Time.now
      end
      @store[key].value
    end

    def acceptable? entry
      return false if entry.nil? || entry.value.nil?
      Time.now - entry.created < duration
    end
  end
end
