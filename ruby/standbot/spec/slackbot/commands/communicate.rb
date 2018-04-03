require 'spec_helper'

describe Slackbot::Commands::Communicate do
  def app
    Slackbot::Bot.instance
  end

  subject { app }

  it 'returns pong' do
    expect(message: "#{SlackRubyBot.config.user} ping", channel: 'channel').to respond_with_slack_message('pong')
  end
end
