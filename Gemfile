source 'http://rubygems.org'

gem 'rails', '3.0.6'

gem 'rake'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'



# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

if /1.9/ === RUBY_VERSION
  gem "ruby-debug19", :require => 'ruby-debug'
else
  gem "ruby-debug"
end

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
gem "arel", "2.0.9"
group :development do
  gem "guard"
  gem "guard-rspec"
  gem "rspec-rails", '2.5.0'
  gem "cucumber-rails"
end

group :test do
  gem "spork"
  gem "guard-spork"
  gem "rspec"
  gem "cucumber"
  gem "rspec-expectations"
#gem "webrat"
  gem "libnotify"
  gem "rb-inotify"
end
# gem "cucumber-rails", :group => ["development", "test"]
# gem "capybara", :group => ["development", "test"]
#gem "factory_girl_rails", :group => ["development", "test"]

gem "rcov"
gem "inherited_resources_views"
gem "inherited_resources"

#gem "jquery-rails"
gem "devise"
if /java/ === RUBY_PLATFORM
  gem "jdbc-mysql"
#  gem "jdbc-sqlite3"
  gem "activerecord-jdbc-adapter"
#  gem "mongrel", :group => ["development"]
  gem "trinidad"
  gem "jruby-openssl"
else
  gem "mysql2", '< 0.3'
  gem "thin"
end
gem "json"
gem "state_machine"
gem "acts_as_tree"
gem "ruby-graphviz", :group => ["development"]
gem "will_paginate", "~> 3.0.pre4"
#gem "redis"
#gem "mvn:org.springframework:spring"
