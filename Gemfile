source 'http://rubygems.org'

gem 'rails', '3.0.5'
gem 'mysql2'
gem "bundler",                    ">=0.9.26"
gem "calendar_date_select",       ">=1.16"
gem "chronic",                    ">=0.2.3"
gem "googlecharts",               ">=1.6.0",    :require => "gchart"
gem "logging",                    ">=1.4.3"
gem "will_paginate",              "~> 3.0.pre2"
gem "packet",                     ">=0.1.15"
gem 'jquery-rails',               ">= 0.2.7"
gem "rake",                       ">=0.8.7",    :require => false
gem "paperclip",                  ">=2.3"
gem 'kaminari'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
#gem "ruby-debug"
#gem 'ruby-debug19', :require => 'ruby-debug'
gem "aasm",                       ">=2.2.0"
gem "thinking-sphinx",            ">=1.3.16"
gem "ts-delayed-delta",           "1.1.1",      :require => "thinking_sphinx/deltas/delayed_delta"
gem "delayed_job",                "2.0.5"

group :development, :test do
  gem "rcov"
  gem "cucumber-rails"       
  gem "rspec-rails",              ">= 2.0.0.beta.19"
  gem "spork"
  gem 'database_cleaner'
  gem "test-unit",                "1.2.3"
  gem "factory_girl_rails",       ">=1.0.1"
end


group :cucumber do  
  gem "factory_girl_rails",       ">=1.0.1"
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'  
  gem "configuration",            "1.1.0"
  gem 'cucumber'            
  gem 'rspec-rails',              ">= 2.0.0.beta.19"  
  gem 'launchy'    # So you can do Then show me the page
end
