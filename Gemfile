ruby "2.0.0"

source 'https://rubygems.org'

gem 'rails', '4.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'thin'

# gem 'puma' # just trying this out https://www.engineyard.com/articles/rails-server
gem 'figaro'
gem 'puma'
gem 'omniauth-twitter'
gem 'twitter'
gem 'activerecord-session_store'
gem 'sprockets-rails'
gem 'protected_attributes'

gem 'pg'
gem 'haml-rails'
gem 'nifty-generators'
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem "bootstrap-sass"
gem 'gmaps4rails'
gem 'inherited_resources'
# gem "coffee-filter", git: 'git://github.com/paulnicholson/coffee-filter.git'
gem "draper"
gem "pry-rails"
gem "friendly_id", '~> 5.0.3'

# Koala is a gem to access and play around easily with Facebook's Graph API
gem "koala"

gem 'figaro'


# DelayedJob is a gem for background jobs. It has two versions, one for mongoid
# and another for active_record. This one is for active record
gem 'delayed_job'
gem "delayed_job_active_record"

# devise-async helps to send jobs in the background supporting resque and delayed_job
# for devise gem
gem "devise-async"

# Used for all the geographical stuff used on Roadmojo. Mainly used on the server side
# and not on the client side, meaning not for Javascript. Only Rails.
gem 'geokit'

# RMagick for rescaling images
# gem 'rmagick'

# for pagination
gem 'kaminari'

# For uploading files
gem 'carrierwave'

# used for auto-uploading multiple files(photos) to s3
# gem 'carrierwave_direct'


# For uploading files directly on Amazon
gem 'fog'

#New Relic
gem 'newrelic_rpm'

# http://errorapp.com is used for exception notifications.
# gem 'errorapp_notifier', git: 'git@github.com:ktkaushik/errorapp_notifier.git'
# gem 'errorapp_notifier'

# Gems used only for assets and not required
# in production environments by default.
gem "compass-rails"
group :assets do
  gem 'sass-rails', '~> 4.0.3'
  gem 'coffee-rails', '~> 4.0.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier'
  # gem 'jquery-fileupload-rails'
end

group :development do
  gem "guard-ctags-bundler"
  gem "guard-rspec"
  gem "guard-spork"
  gem "localtunnel"
end

group :test do
  gem "capybara"
  gem "factory_girl_rails"
end

group :development, :test do
  gem "rspec-rails"
  gem "shoulda-matchers"
end

gem "jquery-rails"
gem "jquery-ui-rails"
gem "bootbox-rails"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
