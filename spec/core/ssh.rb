require "delegate"

module Fog
  module SSH
    def self.new(address, username, options = {})
      if Fog.mocking?
        Fog::SSH::Mock.new(address, username, options)
      else
        Fog::SSH::Real.new(address, username, options)
      end
    end

    class Mock
      def self.data
        @data ||= Hash.new do |hash, key|
          hash[key] = []
        end
      end

      def self.reset
        @data = nil
      end

      def initialize(address, username, options)
        @address  = address
        @username = username
        @options  = options
      end

      def run(commands, &_blk)
        self.class.data[@address] << { :commands => commands, :username => @username, :options => @options }
      end
    end
  end
end
