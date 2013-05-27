get '/' do
  haml :index
end

get '/:username' do |username|
  @user = TwitterUser.find_by_username(username)
  if @user.tweets_stale?
    @user.fetch_tweets!
    p 'fetched data'
  end

  @tweets = @user.tweets.last(10)
  haml :display
end

post '/' do
  TwitterUser.find_or_create_by_username(params[:username])

  redirect "/#{params[:username]}"
end