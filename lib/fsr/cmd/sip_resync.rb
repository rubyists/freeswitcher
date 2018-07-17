# Adding the send_mwi method

require "fsr/app"
module FSR
  module Cmd
    class SipResync < Command
      def initialize(fs_socket = nil, args = {})
        @fs_socket = fs_socket # FSR::CommandSocket obj
        raise(ArgumentError, "No aor given") unless aor
        @options = "\r\nprofile: internal\r\ncontent-type: application/simple-message-summary\r\nevent-string: check-sync\r\nuser: #{aor.split('@')[0]}\r\nhost: #{aor.split('@')[1]}\r\ncontent-lengthcontent-length: 0"
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
        orig_command = "sendevent NOTIFY#{@options}"
      end
    end

  register(:sip_resync, SipResync)
  end
end
