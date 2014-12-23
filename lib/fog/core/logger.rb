module Fog
  class Logger
    @channels = {
      :deprecation  => ::STDERR,
      :warning      => ::STDERR
    }

    @channels[:debug] = ::STDERR if ENV["DEBUG"]

    def self.[](channel)
      @channels[channel]
    end

    def self.[]=(channel, value)
      @channels[channel] = value
    end

    def self.debug(message)
      write(:debug, "[light_black][fog][DEBUG] #{message}[/]\n")
    end

    def self.deprecation(message)
      write(:deprecation, "[yellow][fog][DEPRECATION] #{message}[/]\n")
    end

    def self.warning(message)
      write(:warning, "[yellow][fog][WARNING] #{message}[/]\n")
    end

    def self.write(key, value)
      channel = @channels[key]
      if channel
        message = if channel.tty?
                    value.gsub(::Formatador::PARSE_REGEX) { "\e[#{::Formatador::STYLES[$1.to_sym]}m" }.gsub(::Formatador::INDENT_REGEX, "")
                  else
                    value.gsub(::Formatador::PARSE_REGEX, "").gsub(::Formatador::INDENT_REGEX, "")
                  end
        channel.write(message)
      end
      nil
    rescue ::Errno::EBADF
      # Prevent issues with the console from affecting the main operation
      # Such as uploading an object to S3
      return nil if @channels[key] == ::STDERR
      raise
    end
  end
end
