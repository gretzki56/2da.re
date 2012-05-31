# By Oto Brglez - <oto.brglez@opalab.com>

source 'http://rubygems.org'

gem 'rails', '3.2.1'
gem 'haml', '>= 3.0.0'
gem 'sass'
gem 'jquery-rails'
gem 'haml-rails'

gem 'simple_form'
gem 'inherited_resources'

gem 'omniauth'
gem 'omniauth-facebook'

gem 'heroku'

gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'mini_magick'

gem 'rabl'
gem 'httparty'


gem "mongoid", ">= 2.4"
gem "bson_ext"

gem 'pry', :group => :development
gem 'pry-rails', :group => :development

gem 'draper'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-ui-rails'
end

group :production do
	gem 'therubyracer-heroku'
end

group :development do
	gem 'unicorn'
	gem 'foreman'
end

group :test do
#	gem 'cucumber-rails'
end

group :development, :test do
	gem 'ruby-debug19', :require => 'ruby-debug'
	gem 'rails3-generators'

	gem 'rspec'
	gem 'rspec-rails'
	gem 'growl'

	gem 'autotest'
	gem 'autotest-growl'
	
	gem 'database_cleaner'
	gem 'spork'
	gem 'fuubar'
	gem 'fuubar-cucumber'
	gem 'rack-test'
	
	gem 'factory_girl_rails', :git =>'git://github.com/thoughtbot/factory_girl_rails.git', :tag => 'v1.2.0'

	gem 'guard'
	gem 'guard-spork'
	gem 'guard-cucumber'
	gem 'guard-rspec'
	gem 'guard-bundler'
	gem 'guard-pow'
	gem 'guard-livereload'
 	
 	gem 'rb-fsevent', :require => false

	gem 'capybara'
 	gem 'mongoid-rspec', :require => false
end
