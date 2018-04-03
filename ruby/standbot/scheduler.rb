require 'slack-ruby-bot'

class Imbot
  # Get the bot's Slack API client
  def self.slack_client
    @slack_client ||= ::Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
  end

  # This the channel_id an IM message?
  def self.slack_im?(channel_id)
    !!(channel_id =~ /\AD/)
  end

  # returns the channel id of an open IM channel
  def self.slack_im_open!(user_slack_id)
    @im_opens ||= {}
    return @im_opens[user_slack_id] if @im_opens[user_slack_id]

    begin
      im = slack_client.im_open(user: user_slack_id)
      im_channel_id = im && im['channel'] && im['channel']['id']
      return @im_opens[user_slack_id] = im_channel_id
    rescue => err
      STDERR.puts err.to_s
      STDERR.puts "Error opening IM channel: #{user_slack_id}"
      return nil
    end
  end
end

client = Imbot.slack_client
channel = client.channels_info(channel: "#kyrres-test-kanal").channel
channel.members.each do |slackid|
  imid = Imbot.slack_im_open!(slackid)
  client.chat_postMessage(text: "hello world", channel: imid) if imid
end

