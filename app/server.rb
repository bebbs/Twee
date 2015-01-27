require 'sinatra/base'
require 'twitter'

class Twee < Sinatra::Base
  get '/' do
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end

    fresh_tweets = client.search("/*/ -rt", lang: 'en').take(100)
    @tweets = []
    fresh_tweets.each do |tweet|
      new_text = tweet.dup
      new_text.gsub!('@^(http?|ftp)://[^\s/$.?#].[^\s]*$@iS', '')
      @tweets << new_text
    end

    erb :index
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
