require 'sinatra/base'

module Slackbot
  class Web < Sinatra::Base
    get '/' do
      'Math is good for you.'
    end

    get '/standups' do
      haml(:reports, :locals => {'all' => Standup.all})
    end
  end
end
