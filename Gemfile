source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
# gem "rack-cors"
# gem "jbuilder"
gem "dotenv", "~> 3.1"
gem "bcrypt", "~> 3.1"
gem "warden", "~> 1.2"
gem "jwt", "~> 2.10"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "faker", "~> 3.5"
  gem "pry-rails", "~> 0.3.11"
end

group :test do
  gem "rspec-rails", "~> 8.0"
end
