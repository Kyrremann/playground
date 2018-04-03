# coding: utf-8

require 'date'

module Slackbot
  module Commands
    class Communicate < SlackRubyBot::Commands::Base
      help do
        title 'Standbot'
        desc 'This bot inform you about standup, and notify the team'

        command 'rapport' do
          desc 'Returns a small report for the current user about todays questions'
          long_desc 'Add "alle" to see a report on all team members'
        end

        command 'igår' do
          desc 'Report activity for each question'
        end

        command 'idag' do
          desc 'Report activity for each question'
        end

        command 'problem' do
          desc 'Report activity for each question'
        end
      end

      command 'rapport' do |client, data, match|
        today = Date.today
        message = ""
        if match['expression'] == 'alle'
          standups = Standup.where(Sequel.function(:date, :created_at) => Date.today).all
          standups.each do |standup|
            message += "<@#{data.user}> rapporterte:\n#{standup.pretty_report}"
          end
        else
          standup = Standup.first(slackid: data.user, Sequel.function(:date, :created_at) => Date.today)
          if standup
            message = "<@#{data.user}> rapporterte:\n#{standup.pretty_report}"
          else
            message = "Ingen rapport fra deg i dag"
          end
        end
        client.say(text: message, channel: data.channel)
      end

      command 'igår', 'idag', 'problem' do |client, data, match|
        id = data.user
        name = client.users[id]['real_name']
        command = command_to_sym(match['command'])
        message = match['expression']
        now = Time.now
        standup = Standup.first(slackid: id, Sequel.function(:date, :created_at) => Date.today)
        if standup.nil?
          standup = Standup.create(:slackid => id, :name => name, command => message, :created_at => now, :updated_at => now)
          standup.save
        else
          standup[command] = message
          standup[:updated_at] = now
          standup.save
        end
        client.say(text: 'notert', channel: data.channel)
      end

      def self.command_to_sym(cmd)
        case cmd
        when 'igår', 'yesterdat'
          :yesterday
        when 'idag', 'today'
          :today
        when 'problem'
          :problems
        end
      end
    end
  end
end
