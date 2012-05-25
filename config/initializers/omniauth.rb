Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :developer unless Rails.env.production?
  provider :facebook, ENV['DARE_FACEBOOK_KEY'], ENV['DARE_FACEBOOK_SECRET'],
  	scope: 'email,offline_access,user_location,publish_stream' #,offline_access,user_location,friends
#  provider :twitter, ENV['RDR_TWITTER_KEY'], ENV['RDR_TWITTER_SECRET']
#  provider :google_oauth2, ENV['RDR_GOOGLE_KEY'], ENV['RDR_GOOGLE_SECRET'], {}
end