class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    user  = tweet.twitter_user

    TwitterClient.for(user)

    Twitter.update(tweet.text)
  end

  def retry(tweet_id)
    tweet = Tweet.find(tweet_id)
    tweet.update_attributes(failed: true)
  end
end
