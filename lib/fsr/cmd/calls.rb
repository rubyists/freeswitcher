require "fsr/app"
module FSR
  module Cmd
    class Calls < Command

      include Enumerable
      TYPES = [:detailed, :bridged, :detailed_bridged]
      def each(&block)
        @calls ||= run
        if @calls
          @calls.each { |call| yield call }
        end
      end

      def initialize(fs_socket = nil, type = nil, filter = nil)
        @type = type
        @filter = filter
        unless @type.nil?
          raise ArgumentError, "Only #{TYPES} are allowed as arguments" unless TYPES.include?(@type)
        end
        @fs_socket = fs_socket # FSR::CommandSocket obj
      end

      # Send the command to the event socket, using bgapi by default.
      def run(api_method = :api)
        orig_command = "%s %s" % [api_method, raw]
        Log.debug "saying #{orig_command}"
        resp = @fs_socket.say(orig_command)
        unless resp["body"] == "0 total."
          call_info, count = resp["body"].split("\n\n")
          require "fsr/model/call"
          require "csv"
          call_info.match(/\{([^)]+)\}/)[0...-1].each do |m|
            ss = m.sub(',', ';')
            @call_info = call_info.gsub(m, ss)
          end
          @calls = CSV.parse(call_info, liberal_parsing: true)
          return @calls[1 .. -1].map { |c| FSR::Model::Call.new(@calls[0],*c) }
        end
        []
      end

      # This method builds the API command to send to the freeswitch event socket
      def raw
        base = if @type.nil?
          "show calls"
        else
          "show %s_calls" % @type
        end
        if @filter
          "%s like '%s'" % [base, @filter]
        else
          base
        end
      end
    end

    register(:calls, Calls)
  end
end
