class TwitterUser < ActiveRecord::Base
  # Remember to create a migration!
  has_many :tweets

  def fetch_tweets!
    tweets = Twitter.user_timeline(username)

    tweets.reverse.each do |tweet|
      unless Tweet.find_by_text(tweet.text)
        a_tweet = Tweet.new(text: tweet.text, created_at: tweet.created_at)
        a_tweet.save
        self.tweets << a_tweet
      end
    end
  end

  def average_tweet_time
    (self.tweets.last.created_at - self.tweets.last(10).first.created_at)/60
  end

  def tweets_stale?
    unless self.tweets.empty?
      limit = average_tweet_time
      minutes = (Time.now - self.tweets.last.created_at)/60
      puts "the limit isssssssssssss #{limit}"
      puts "the limit isssssssssssss #{minutes}"
      minutes > limit
    else
      true
    end
  end
end