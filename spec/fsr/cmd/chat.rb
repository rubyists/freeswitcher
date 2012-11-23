require 'spec/helper'
require "fsr/cmd"
FSR::Cmd.load_command("chat")

describe "Testing FSR::Cmd::Chat" do
  # Invalid originates
  it "Must be passed an argument hash" do
    lambda { FSR::Cmd::Chat.new(nil, :endpoint) }.should.raise(ArgumentError).
      message.should.match(/args \(Passed: <<<.*?>>>\) must be a hash/)
  end

  it "Can not send a chat without a message" do
    lambda { FSR::Cmd::Chat.new(nil, :to => '1000', :from => '1001') }.should.raise(ArgumentError).
      message.should.match(/Cannot send chat without :message set/)
  end

  it "Can not send a chat without to set" do
    lambda { FSR::Cmd::Chat.new(nil, :message => 'Hello', :from => '1001') }.should.raise(ArgumentError).
      message.should.match(/Cannot send chat without :to set/)
  end

  it "Can not send a chat without from set" do
    lambda { FSR::Cmd::Chat.new(nil, :message => 'Hello', :to => '1000') }.should.raise(ArgumentError).
      message.should.match(/Cannot send chat without :from set/)
  end

  it "Can not send a chat with invalid protocol" do
    lambda { FSR::Cmd::Chat.new(nil, :message => 'Hello', :to => '1000', :from => '1001', :protocol => '') }.should.raise(ArgumentError).
      message.should.match(/Cannot send chat with invalid protocol/)
  end

  it "Creates a valid chat message with sensible default protocol" do
    chat = FSR::Cmd::Chat.new(nil, :message => 'Hello', :to => '1000', :from => '1001')
    chat.raw.should == "chat sip|1001|1000|Hello"
  end

  # Different options choices
  it "Honours different protocols" do
    chat = FSR::Cmd::Chat.new(nil, :message => 'Hello', :to => '1000', :from => '1001', :protocol => 'jingle')
    chat.raw.should == "chat jingle|1001|1000|Hello"
  end

  it "Honours a more realistic to" do
    chat = FSR::Cmd::Chat.new(nil, :message => 'Hello', :to => '1000@192.168.1.1', :from => '1001')
    chat.raw.should == "chat sip|1001|1000@192.168.1.1|Hello"
  end

  it "Honours a more complex message" do
    chat = FSR::Cmd::Chat.new(nil, :message => 'Hello, friendly sir. "*/;{(\|/;,@#,/', :to => '1000@192.168.1.1', :from => '1001')
    chat.raw.should == 'chat sip|1001|1000@192.168.1.1|Hello, friendly sir. "*/;{(\\\|/;,@#,/'
  end

  it "Escapes pipes from messages" do
    chat = FSR::Cmd::Chat.new(nil, :message => 'He||o there |ove|y', :to => '1000@192.168.1.1', :from => '1001')
    chat.raw.should == %Q(chat sip|1001|1000@192.168.1.1|He\\|\\|o there \\|ove\\|y)
  end

end