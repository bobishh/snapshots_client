require 'timelapser_client/command/shoot'
require 'timelapser_client/command/send'

module TimelapserClient
  class Command
    attr_reader :options, :command_symbol

    def initialize(command_symbol, options = {})
      @options = options
      @command_symbol = command_symbol
    end

    def command
      @command ||= infer_command(command_symbol)
    end

    def run!
      command.run!
    end

    private

    def infer_command(sym)
      command_class(sym).new(@options)
    end

    def command_class(sym)
      str = sym.to_s
      str[0] = str[0].upcase
      @command_class ||= Object.const_get("TimelapserClient::Command::#{str}")
    end
  end
end
