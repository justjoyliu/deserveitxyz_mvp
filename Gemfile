source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'sqlite3'
gem 'sass-rails', '~> 5.0' # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0' # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks' # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'jbuilder', '~> 2.0' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'sdoc', '~> 0.4.0', group: :doc # bundle exec rake doc:rails generates the API under doc/api.

# gem 'therubyracer', platforms: :ruby # See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'unicorn' # Use Unicorn as the app server

gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password
gem 'annotate'
gem 'puma',           '2.11.1' #for productionizing: an HTTP server that is capable of handling a large number of incoming requests.
gem 'figaro' # keep secret keys safe in config/application.yml; need to run bundle exec figaro install

# styling
gem 'bootstrap-sass',       '3.2.0.0'
gem 'client_side_validations', github: "DavyJonesLocker/client_side_validations", branch: "4-2-stable" #live form validation, need to run rails g client_side_validations:install
gem "chartkick" #pie progress chart

gem 'twilio-ruby'


group :development, :test do
  # gem 'capistrano-rails', group: :development # Use Capistrano for deployment
  gem 'byebug' # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'web-console', '~> 2.0' # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'spring'   # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
end

