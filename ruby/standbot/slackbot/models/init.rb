require 'sequel'

database_url = ENV['DATABASE_URL'] ? ENV['DATABASE_URL'] : 'postgres://postgres:postgres@localhost:5432/postgres'
DB = Sequel.connect(database_url)

require 'slackbot/models/standup'
