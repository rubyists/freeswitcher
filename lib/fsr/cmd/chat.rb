require "fsr/app"
module FSR
  module Cmd
    class Chat < Command

      attr_reader :fs_socket

      def initialize(fs_socket = nil, args = {})
        
        raise(ArgumentError, "args (Passed: <<<#{args}>>>) must be a hash") unless args.kind_of?(Hash)

        @fs_socket = fs_socket # FSR::CommandSocket obj
        @protocol = args[:protocol] ? args[:protocol] : 'sip'
        raise(ArgumentError, "Cannot send chat with invalid protocol") unless @protocol.to_s.size > 0
        @from = args[:from] # i.e. 1000@192.168.1.1
        raise(ArgumentError, "Cannot send chat without :from set") unless @from.to_s.size > 0
        @to   = args[:to]   # i.e. 1001@192.168.1.1
        raise(ArgumentError, "Cannot send chat without :to set") unless @to.to_s.size > 0
        @message = args[:message]
        raise(ArgumentError, "Cannot send chat without :message set") unless @message.to_s.size > 0
        @message.gsub!('|', '\|')
      end

      # Send the command to the event socket, using api by default.
      def run(api_method = :api)
        orig_command = "%s %s" % [api_method, raw]
        Log.debug "saying #{orig_command}"
        @fs_socket.say(orig_command)
      end
    
      # This method builds the API command to send to the freeswitch event socket
      def raw
        %Q(chat #{@protocol}|#{@from}|#{@to}|#{@message})
      end
    end

    register(:chat, Chat) 
  end
end