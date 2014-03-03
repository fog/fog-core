require "fog/core/errors"

module Fog
  module Core

    # Fog::Core::Connection is a generic class to contain a HTTP link to an API.
    #
    # It is intended to be subclassed by providers who can then add their own
    # modifications such as authentication or response object.
    #
    class Connection

      attr_reader :http_client
      # Prepares the connection and sets defaults for any future requests.
      #
      # @param [String] url The destination URL
      # @param persistent [Boolean]
      # @param [Hash] params
      # @option params [String] :body Default text to be sent over a socket. Only used if :body absent in Connection#request params
      # @option params [Hash<Symbol, String>] :headers The default headers to supply in a request. Only used if params[:headers] is not supplied to Connection#request
      # @option params [String] :host The destination host's reachable DNS name or IP, in the form of a String
      # @option params [String] :path Default path; appears after 'scheme://host:port/'. Only used if params[:path] is not supplied to Connection#request
      # @option params [Fixnum] :port The port on which to connect, to the destination host
      # @option params [Hash]   :query Default query; appended to the 'scheme://host:port/path/' in the form of '?key=value'. Will only be used if params[:query] is not supplied to Connection#request
      # @option params [String] :scheme The protocol; 'https' causes OpenSSL to be used
      # @option params [String] :proxy Proxy server; e.g. 'http://myproxy.com:8888'
      # @option params [Fixnum] :retry_limit Set how many times we'll retry a failed request.  (Default 4)
      # @option params [Class] :instrumentor Responds to #instrument as in ActiveSupport::Notifications
      # @option params [String] :instrumentor_name Name prefix for #instrument events.  Defaults to 'excon'
      # @option params [Class]  :http_client Set the network layer provider, defaults to Exconn
      #
      def initialize(url, persistent=false, params={})
        unless params.has_key?(:debug_response)
          params[:debug_response] = true
        end
        params[:headers] ||= {}
        params[:headers]['User-Agent'] ||= "fog/#{Fog::VERSION}"
        params.merge!(:persistent => params.fetch(:persistent, persistent))
        client = params.delete(:http_client)
        params.merge!(:url => url)
        @http_client = client_builder(client, params)
      end



      # Makes a request using the connection using Excon
      #
      # @param [Hash] params
      # @option params [String] :body text to be sent over a socket
      # @option params [Hash<Symbol, String>] :headers The default headers to supply in a request
      # @option params [String] :host The destination host's reachable DNS name or IP, in the form of a String
      # @option params [String] :path appears after 'scheme://host:port/'
      # @option params [Fixnum] :port The port on which to connect, to the destination host
      # @option params [Hash]   :query appended to the 'scheme://host:port/path/' in the form of '?key=value'
      # @option params [String] :scheme The protocol; 'https' causes OpenSSL to be used
      # @option params [Proc] :response_block
      #
      # @return [Fog::Core::HttpResponse]
      #
      # @raise [Fog::Error::HTTPError]

      #
      def request(params, &block)
        HttpResponse.new(http_client.request(params, &block))
      rescue StandardError => e
        raise Fog::Errors::HTTPError.new(e)
      end

      # Make {#request} available even when it has been overidden by a subclass
      # to allow backwards compatibility.
      #
      alias_method :original_request, :request
      protected :original_request

      # Closes the connection
      #
      def reset
        http_client.reset
      end

      private

      def client_builder(client, params)
        if client
          client.new(params)
        else
          url = params.delete(:url)
          Excon.new(url, params)
        end
      end
    end
  end
end
