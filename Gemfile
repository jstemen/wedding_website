source 'https://rubygems.org'
ruby '2.2.2'
gem 'rails', '~> 4.2'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development
gem 'bootstrap-sass'
gem 'high_voltage'
gem 'therubyracer', :platform=>:ruby
gem 'unicorn'
gem 'unicorn-rails'
gem 'underscore-rails'
gem 'formtastic'
gem 'faker'
gem 'devise'
gem "nilify_blanks"
gem 'smarter_csv'
gem 'delayed_job_active_record'
gem 'pry-byebug'

group :development do
  gem 'guard-ctags-bundler'
  gem 'better_errors'
  gem 'guard-livereload'
  gem "rack-livereload"
  gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'quiet_assets'
  gem 'rails_layout'

  gem "awesome_print"
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'guard'
end
group :production do
  gem 'mysql2'
  gem 'rails_12factor'
end
group :test do
  gem 'rspec-activemodel-mocks'
  gem 'capybara-email'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end
