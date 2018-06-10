require "fsr/app"
module FSR
  module Cmd
    class UuidHold < Command
      DEFAULTS = {}
      def initialize(fs_socket = nil, args = {})
        @fs_socket = fs_socket # FSR::CommandSocket obj
        args = DEFAULTS.merge(args)
        @uuid = args.values_at(:uuid)
        raise(ArgumentError, "No uuid given") unless @uuid
      end

      # Send the command to the event socket, using bgapi by default.
      def run(api_method = :api)
        orig_command = "%s %s" % [api_method, raw]
        Log.debug "saying #{orig_command}"
        @fs_socket.say(orig_command)
      end

      # This method builds the API command to send to the freeswitch event socket
      def raw
        "uuid_hold toggle #{@uuid}"
      end
    end

    register(:uuid_hold, UuidHold)
  end
end
