source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'bcrypt', '~> 3.1.7'
gem 'ffaker'
gem 'jbuilder', '~> 2.5'
gem 'kaminari'
gem 'knock'
gem 'mysql2'
gem 'puma', '~> 3.0'
gem 'rack-cors', require: 'rack/cors'
gem 'rails', '~> 5.0'
gem 'swagger-blocks'

group :development, :test do
  gem 'database_rewinder'
  gem 'factory_girl_rails'
  gem 'pry-byebug'
  gem 'rspec-json_matcher'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
