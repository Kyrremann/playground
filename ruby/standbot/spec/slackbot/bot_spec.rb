require 'spec_helper'

describe Slackbot::Bot do
  def app
    Slackbot::Bot.instance
  end

  subject { app }

  it_behaves_like 'a slack ruby bot'
end
