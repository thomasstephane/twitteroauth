get '/' do
  erb :index
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
  @username =  @access_token.params[:screen_name]
  
  @user = TwitterUser.find_or_create_by_username_and_oauth_token_and_oauth_token_secret(username: @access_token.params[:screen_name], oauth_token: @access_token.params[:oauth_token], oauth_token_secret: @access_token.params[:oauth_token_secret])
  session.delete(:request_token)

  session[:user_id] = @user.id
  
  erb :index
end

get '/status/:job_id' do
  if job_is_complete(params[:job_id])
    tweet = Tweet.find_by_job_id(params[:job_id])
    p tweet.failed
    return 'Tweeted!' unless tweet.failed
    return 'Failed...'
  else
    return 400
  end
end

post '/tweet' do
  current_user.tweet(params[:text], params[:delay].to_i)
end