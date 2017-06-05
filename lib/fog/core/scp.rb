module Fog
  module SCP
    class Real
      def initialize(address, username, options)
        begin
          require "net/scp"
        rescue LoadError
          Fog::Logger.warning("'net/scp' missing, please install and try again.")
          exit(1)
        end

        key_manager = Net::SSH::Authentication::KeyManager.new(nil, options)

        unless options[:key_data] || options[:keys] || options[:password] || key_manager.agent
          raise ArgumentError, ":key_data, :keys, :password or a loaded ssh-agent is required to initialize SSH"
        end

        options[:timeout] = 30
        if options[:key_data] || options[:keys]
          options[:keys_only] = true
          # Explicitly set these so net-ssh doesn't add the default keys
          # as seen at https://github.com/net-ssh/net-ssh/blob/master/lib/net/ssh/authentication/session.rb#L131-146
          options[:keys] = [] unless options[:keys]
          options[:key_data] = [] unless options[:key_data]
        end

        @address  = address
        @username = username
        @options  = { :paranoid => false }.merge(options)
      end

      def upload(local_path, remote_path, upload_options = {}, &block)
        Net::SCP.start(@address, @username, @options) do |scp|
          scp.upload!(local_path, remote_path, upload_options) do |ch, name, sent, total|
            block.call(ch, name, sent, total) if block
          end
        end
      rescue Exception => error
        raise error
      end

      def download(remote_path, local_path, download_options = {}, &block)
        Net::SCP.start(@address, @username, @options) do |scp|
          scp.download!(remote_path, local_path, download_options) do |ch, name, sent, total|
            block.call(ch, name, sent, total) if block
          end
        end
      rescue Exception => error
        raise error
      end
    end
  end
end
