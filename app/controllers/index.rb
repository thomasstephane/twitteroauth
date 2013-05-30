get '/' do
  erb :index
end


post '/' do
  TwitterUser.find_or_create_by_username(params[:username])

  redirect "/#{params[:username]}"
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  session.delete(:request_token)
  
  user = TwitterUser.find_or_create_by_username_and_oauth_token_and_oauth_token_secret(username: @access_token.params[:screen_name], oauth_token: @access_token.params[:oauth_token], oauth_token_secret: @access_token.params[:oauth_token_secret])

  redirect "/#{user.username}/profile"
end

get '/:username/profile' do |username|
  @user = TwitterUser.find_by_username(username)

  TwitterClient.for(@user)

  if @user.tweets_stale?
    @user.fetch_tweets!
    p 'fetched data'
  end

  @tweets = @user.tweets.last(10)
  haml :display
end

# get '/status/:job_id' do
#   TwitterClient.job_is_complete(:job_id)  
# end

# get '/status/update' do 
#   erb :tweet
# end

# post '/status/update'
# end