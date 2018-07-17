# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{freeswitcher}
  s.version = "0.4.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jayson Vaughn", "Michael Fellinger", "Kevin Berry", "TJ Vanderpoel"]
  s.date = %q{2010-01-22}
  s.description = %q{=========================================================
FreeSWITCHeR
Copyright (c) 2009 The Rubyists (Jayson Vaughn, Tj Vanderpoel, Michael Fellinger, Kevin Berry) 
Distributed under the terms of the MIT License.
==========================================================

ABOUT
-----
A ruby library for interacting with the "FreeSWITCH" (http://www.freeswitch.org) opensource telephony platform

REQUIREMENTS
------------
* ruby (>= 2.4)
* eventmachine (If you wish to use Outbound and Inbound listener)

USAGE
-----

An Outbound Event Listener Example that reads and returns DTMF input:
--------------------------------------------------------------------

Simply just create a subclass of FSR::Listner::Outbound and all
new calls/sessions will invoke the "session_initiated" callback method.
 
<b>NOTE</b>: FSR uses blocks within the 'session_inititated' method to ensure that the next "freeswich command" is not executed until the previous "Freeswitch command" has finished.  (Basically a continuation) This is kicked off by "answer do". 

  #!/usr/bin/ruby
  require 'fsr'
  require 'fsr/listener/outbound'

  class OutboundDemo < FSR::Listener::Outbound

    def session_initiated
      exten = @session.headers[:caller_caller_id_number]
      FSR::Log.info "*** Answering incoming call from #{exten}"

      answer do
        FSR::Log.info "***Reading DTMF from #{exten}"
        read("/home/freeswitch/freeswitch/sounds/music/8000/sweet.wav", 4, 10, "input", 7000) do |read_var|
          FSR::Log.info "***Success, grabbed #{read_var.to_s.strip} from #{exten}"
          # Tell the caller what they entered
          speak("Got the DTMF of: #{read_var.to_s.strip}") do 
            #Hangup the call
            hangup 
          end
        end
      end

    end

  end

  FSR.start_oes! OutboundDemo, :port => 8084, :host => "127.0.0.1"

An Inbound Event Socket Listener example using FreeSWITCHeR's hook system:
--------------------------------------------------------------------------

  #!/usr/bin/ruby
  require 'pp'
  require 'fsr'
  require "fsr/listener/inbound"

  # EXAMPLE 1 
  # This adds a hook on CHANNEL_CREATE events. You can also create a method to handle the event you're after. See the next example
  FSL::Inbound.add_event_hook(:CHANNEL_CREATE) { FSR::Log.info "*** [#{event.content[:unique_id]}] Channel created - greetings from the hook!" }

  # EXAMPLE 2
  # Define a method to handle CHANNEL_HANGUP events.
  def custom_channel_hangup_handler(event)
    FSR::Log.info "*** [#{event.content[:unique_id]}] Channel hangup. The event:"
    pp event
  end

  # This adds a hook for EXAMPLE 2
  FSL::Inbound.add_event_hook(:CHANNEL_HANGUP) { custom_channel_hangup_handler(event) }


  # Start FSR Inbound Listener
  FSR.start_ies!(FSL::Inbound, :host => "localhost", :port => 8021)


An Inbound Event Socket Listener example using the on_event callback method instead of hooks:
---------------------------------------------------------------------------------------------

  #!/usr/bin/ruby
  require 'pp'
  require 'fsr'
  require "fsr/listener/inbound"


  class IesDemo < FSR::Listener::Inbound

    def on_event
      pp event.headers
      pp event.content[:event_name]
    end

  end

  FSR.start_ies!(IesDemo, :host => "localhost", :port => 8021, :auth => "ClueCon")


An example of using FSR::CommandSocket to originate a new call in irb:
----------------------------------------------------------------------

  irb(main):001:0> require 'fsr'
  => true

  irb(main):002:0> FSR.load_all_commands
  => [:sofia, :originate]

  irb(main):003:0> sock = FSR::CommandSocket.new
  => #<FSR::CommandSocket:0xb7a89104 @server="127.0.0.1", @socket=#<TCPSocket:0xb7a8908c>, @port="8021", @auth="ClueCon">

  irb(main):007:0> sock.originate(:target => 'sofia/gateway/carlos/8179395222', :endpoint => FSR::App::Bridge.new("user/bougyman")).run
  => {"Job-UUID"=>"732075a4-7dd5-4258-b124-6284a82a5ae7", "body"=>"", "Content-Type"=>"command/reply", "Reply-Text"=>"+OK Job-UUID: 732075a4-7dd5-4258-b124-6284a82a5ae7"}



SUPPORT
-------
Home page at http://code.rubyists.com/projects/fs
#rubyists on FreeNode
}
  s.email = %q{FreeSWITCHeR@rubyists.com}
  s.files = [".gitignore", "AUTHORS", "CHANGELOG", "License.txt", "MANIFEST", "NEWS", "README", "Rakefile", "examples/inbound_event_socket.rb", "examples/inbound_socket_events.rb", "examples/outbound_event_socket.rb", "freeswitcher.gemspec", "lib/fsr.rb", "lib/fsr/app.rb", "lib/fsr/app/answer.rb", "lib/fsr/app/bind_meta_app.rb", "lib/fsr/app/bridge.rb", "lib/fsr/app/conference.rb", "lib/fsr/app/execute_app.rb", "lib/fsr/app/fifo.rb", "lib/fsr/app/fs_break.rb", "lib/fsr/app/fs_sleep.rb", "lib/fsr/app/hangup.rb", "lib/fsr/app/limit.rb", "lib/fsr/app/log.rb", "lib/fsr/app/play_and_get_digits.rb", "lib/fsr/app/playback.rb", "lib/fsr/app/read.rb", "lib/fsr/app/set.rb", "lib/fsr/app/speak.rb", "lib/fsr/app/transfer.rb", "lib/fsr/app/uuid_dump.rb", "lib/fsr/app/uuid_getvar.rb", "lib/fsr/app/uuid_setvar.rb", "lib/fsr/cmd.rb", "lib/fsr/cmd/calls.rb", "lib/fsr/cmd/fsctl.rb", "lib/fsr/cmd/originate.rb", "lib/fsr/cmd/sofia.rb", "lib/fsr/cmd/sofia/profile.rb", "lib/fsr/cmd/sofia/status.rb", "lib/fsr/cmd/sofia_contact.rb", "lib/fsr/cmd/status.rb", "lib/fsr/cmd/uuid_dump.rb", "lib/fsr/command_socket.rb", "lib/fsr/database.rb", "lib/fsr/database/call_limit.rb", "lib/fsr/database/core.rb", "lib/fsr/database/sofia_reg_external.rb", "lib/fsr/database/sofia_reg_internal.rb", "lib/fsr/database/voicemail_default.rb", "lib/fsr/event_socket.rb", "lib/fsr/fake_socket.rb", "lib/fsr/listener.rb", "lib/fsr/listener/header_and_content_response.rb", "lib/fsr/listener/inbound.rb", "lib/fsr/listener/inbound/event.rb", "lib/fsr/listener/mock.rb", "lib/fsr/listener/outbound.rb", "lib/fsr/model/call.rb", "lib/fsr/version.rb", "tasks/authors.rake", "tasks/bacon.rake", "tasks/changelog.rake", "tasks/copyright.rake", "tasks/gem.rake", "tasks/gem_installer.rake", "tasks/install_dependencies.rake", "tasks/manifest.rake", "tasks/release.rake", "tasks/reversion.rake", "tasks/setup.rake", "tasks/yard.rake", "spec/helper.rb", "spec/fsr_listener_helper.rb", "spec/fsr/app.rb", "spec/fsr/app/answer.rb", "spec/fsr/app/bind_meta_app.rb", "spec/fsr/app/bridge.rb", "spec/fsr/app/conference.rb", "spec/fsr/app/execute_app.rb", "spec/fsr/app/fifo.rb", "spec/fsr/app/fs_break.rb", "spec/fsr/app/fs_sleep.rb", "spec/fsr/app/hangup.rb", "spec/fsr/app/limit.rb", "spec/fsr/app/log.rb", "spec/fsr/app/play_and_get_digits.rb", "spec/fsr/app/playback.rb", "spec/fsr/app/set.rb", "spec/fsr/app/transfer.rb", "spec/fsr/cmd.rb", "spec/fsr/cmd/calls.rb", "spec/fsr/cmd/originate.rb", "spec/fsr/cmd/sofia.rb", "spec/fsr/cmd/sofia/profile.rb", "spec/fsr/cmd/uuid_dump.rb", "spec/fsr/listener.rb", "spec/fsr/listener/header_and_content_response.rb", "spec/fsr/listener/inbound.rb", "spec/fsr/listener/outbound.rb", "spec/fsr/loading.rb"]
  s.homepage = %q{http://code.rubyists.com/projects/fs}
  s.post_install_message = %q{=========================================================
FreeSWITCHeR
Copyright (c) 2009 The Rubyists (Jayson Vaughn, Tj Vanderpoel, Michael Fellinger, Kevin Berry) 
Distributed under the terms of the MIT License.
==========================================================

ABOUT
-----
A ruby library for interacting with the "FreeSWITCH" (http://www.freeswitch.org) opensource telephony platform

REQUIREMENTS
------------
* ruby (>= 2.4)
* eventmachine (If you wish to use Outbound and Inbound listener)

USAGE
-----

An Outbound Event Listener Example that reads and returns DTMF input:
--------------------------------------------------------------------

Simply just create a subclass of FSR::Listner::Outbound and all
new calls/sessions will invoke the "session_initiated" callback method.
 
<b>NOTE</b>: FSR uses blocks within the 'session_inititated' method to ensure that the next "freeswich command" is not executed until the previous "Freeswitch command" has finished.  (Basically a continuation) This is kicked off by "answer do". 

  #!/usr/bin/ruby
  require 'fsr'
  require 'fsr/listener/outbound'

  class OutboundDemo < FSR::Listener::Outbound

    def session_initiated
      exten = @session.headers[:caller_caller_id_number]
      FSR::Log.info "*** Answering incoming call from #{exten}"

      answer do
        FSR::Log.info "***Reading DTMF from #{exten}"
        read("/home/freeswitch/freeswitch/sounds/music/8000/sweet.wav", 4, 10, "input", 7000) do |read_var|
          FSR::Log.info "***Success, grabbed #{read_var.to_s.strip} from #{exten}"
          # Tell the caller what they entered
          speak("Got the DTMF of: #{read_var.to_s.strip}") do 
            #Hangup the call
            hangup 
          end
        end
      end

    end

  end

  FSR.start_oes! OutboundDemo, :port => 8084, :host => "127.0.0.1"

An Inbound Event Socket Listener example using FreeSWITCHeR's hook system:
--------------------------------------------------------------------------

  #!/usr/bin/ruby
  require 'pp'
  require 'fsr'
  require "fsr/listener/inbound"

  # EXAMPLE 1 
  # This adds a hook on CHANNEL_CREATE events. You can also create a method to handle the event you're after. See the next example
  FSL::Inbound.add_event_hook(:CHANNEL_CREATE) { FSR::Log.info "*** [#{event.content[:unique_id]}] Channel created - greetings from the hook!" }

  # EXAMPLE 2
  # Define a method to handle CHANNEL_HANGUP events.
  def custom_channel_hangup_handler(event)
    FSR::Log.info "*** [#{event.content[:unique_id]}] Channel hangup. The event:"
    pp event
  end

  # This adds a hook for EXAMPLE 2
  FSL::Inbound.add_event_hook(:CHANNEL_HANGUP) { custom_channel_hangup_handler(event) }


  # Start FSR Inbound Listener
  FSR.start_ies!(FSL::Inbound, :host => "localhost", :port => 8021)


An Inbound Event Socket Listener example using the on_event callback method instead of hooks:
---------------------------------------------------------------------------------------------

  #!/usr/bin/ruby
  require 'pp'
  require 'fsr'
  require "fsr/listener/inbound"


  class IesDemo < FSR::Listener::Inbound

    def on_event
      pp event.headers
      pp event.content[:event_name]
    end

  end

  FSR.start_ies!(IesDemo, :host => "localhost", :port => 8021, :auth => "ClueCon")


An example of using FSR::CommandSocket to originate a new call in irb:
----------------------------------------------------------------------

  irb(main):001:0> require 'fsr'
  => true

  irb(main):002:0> FSR.load_all_commands
  => [:sofia, :originate]

  irb(main):003:0> sock = FSR::CommandSocket.new
  => #<FSR::CommandSocket:0xb7a89104 @server="127.0.0.1", @socket=#<TCPSocket:0xb7a8908c>, @port="8021", @auth="ClueCon">

  irb(main):007:0> sock.originate(:target => 'sofia/gateway/carlos/8179395222', :endpoint => FSR::App::Bridge.new("user/bougyman")).run
  => {"Job-UUID"=>"732075a4-7dd5-4258-b124-6284a82a5ae7", "body"=>"", "Content-Type"=>"command/reply", "Reply-Text"=>"+OK Job-UUID: 732075a4-7dd5-4258-b124-6284a82a5ae7"}



SUPPORT
-------
Home page at http://code.rubyists.com/projects/fs
#rubyists on FreeNode
}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{freeswitcher}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A library for interacting with the "FreeSWITCH":http://freeswitch.org telephony platform}
  s.test_files = ["spec/fsr/app.rb", "spec/fsr/app/answer.rb", "spec/fsr/app/bind_meta_app.rb", "spec/fsr/app/bridge.rb", "spec/fsr/app/conference.rb", "spec/fsr/app/execute_app.rb", "spec/fsr/app/fifo.rb", "spec/fsr/app/fs_break.rb", "spec/fsr/app/fs_sleep.rb", "spec/fsr/app/hangup.rb", "spec/fsr/app/limit.rb", "spec/fsr/app/log.rb", "spec/fsr/app/play_and_get_digits.rb", "spec/fsr/app/playback.rb", "spec/fsr/app/set.rb", "spec/fsr/app/transfer.rb", "spec/fsr/cmd.rb", "spec/fsr/cmd/calls.rb", "spec/fsr/cmd/originate.rb", "spec/fsr/cmd/sofia.rb", "spec/fsr/cmd/sofia/profile.rb", "spec/fsr/cmd/uuid_dump.rb", "spec/fsr/listener.rb", "spec/fsr/listener/header_and_content_response.rb", "spec/fsr/listener/inbound.rb", "spec/fsr/listener/outbound.rb", "spec/fsr/loading.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0"])
  end
end
