# TIY-DC-ROR
remove_file "Gemfile"
run "touch Gemfile"

add_source "https://rubygems.org"

gem "rails", "4.2.6"

gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"

gem "jquery-rails"
gem "turbolinks"
gem "active_model_serializers"
gem "sdoc", "~> 0.4.0", group: :doc

gem "devise"
gem "twitter-bootstrap-rails"
# gem 'simple_form'
gem "kaminari"

gem_group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "pry-rails"
  gem "quiet_assets"
end

gem_group :test, :development do
  gem "ffaker"
  gem "sqlite3"
end

gem_group :production do
  gem "pg"
  gem "rails_12factor"
end

inside "config" do
  remove_file "database.yml"
  create_file "database.yml" do
    <<-EOF
default: &default
  adapter: sqlite3
  pool: 5
  timeout: 5000

development:
  <<: *default
  database: db/#{app_name}_dev.sqlite3

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: db/#{app_name}_test.sqlite3

EOF
  end
end

after_bundle do
  generate "devise:install"
  generate "devise", "User"

  remove_file "app/views/layouts/application.html.erb"
  generate "bootstrap:install", "static"
  generate "bootstrap:layout"
  # generate "simple_form:install --bootstrap"

  rake "db:create"
  rake "db:migrate"

  git :init
  git add: "."
  git commit: %( -m 'Initial commit')
end
