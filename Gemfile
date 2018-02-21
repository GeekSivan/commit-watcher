source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.5'

# Use mysql + sequel instead of ActiveRecord
gem 'mysql2'
gem 'sequel-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 2.7.2'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '>=5.0.1'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Easy to configure environment variables in config/application.yml
gem 'figaro', '~> 1.1.1'

# Queues and workers and jobs, oh my!
gem 'sidekiq', '~> 4.2.1'
gem "sidekiq-cron", "~> 0.4.2"
gem 'sidekiq-limit_fetch'

# Slack notification integration
gem 'slack-notifier'


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Interface with locally cloned git repos
gem 'rugged', git: 'https://github.com/libgit2/rugged.git', submodules: true

# Parse diffs from GitHub
gem 'git_diff_parser'

# Boolean expression grammar parsing
gem 'citrus'

gem 'sinatra', '>= 2.0.0.beta2', require: nil

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.1.1'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Tests
  gem 'rspec', '~> 3.6.0.beta1'
  gem 'rspec-rails', '~> 3.6.0.beta1'
  gem 'factory_girl_rails'
  gem 'faker'

  # Create hashes that look like classes with methods
  gem 'hash_dot'

  gem 'webmock'
end
