# Adding the send_mwi method

require "fsr/app"
module FSR
  module Cmd
    class SendMwi < Command
      def initialize(fs_socket = nil, args = {})
        @fs_socket = fs_socket # FSR::CommandSocket obj
        @aor, new, read = args.values_at(:aor, :new, :read)
        @read = read.to_i || 0
        @new = new.to_i || 0
        raise(ArgumentError, "No aor given") unless @aor
        raise(ArgumentError, "No new: count given") unless @new
        raise(ArgumentError, "No read: count given") unless @read
        if @new.zero?
          @options = "\r\nMWI-Messages-Waiting: no\r\nMWI-Message-Account: sip:#{@aor}"
        else
          @options = "\r\nMWI-Messages-Waiting: yes\r\nMWI-Message-Account: sip:#{@aor}\r\nMWI-Voice-Message: #{@new}/#{@read} (0/0)"
        end
      end

      # Send the command to the event socket, using api by default.
      def run
        orig_command = raw
        Log.debug "saying #{orig_command}"
        puts "saying #{orig_command}"
        @fs_socket.say(orig_command)
      end
    
      # This method builds the API command to send to the freeswitch event socket
      def raw
        orig_command = "sendevent  message_waiting#{@options}"
      end
    end

  register(:send_mwi, SendMwi)
  end
end
