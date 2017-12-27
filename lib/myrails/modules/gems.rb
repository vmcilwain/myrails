module Install
  module Gems
    def self.included(thor)
      thor.class_eval do
          def install_gems
            insert_into_file 'Gemfile', before: "group :development, :test do" do <<-CODE
    group :test do
      gem 'simplecov'
      gem 'shoulda-matchers'
      gem 'factory_bot_rails'
      gem 'database_cleaner'
      gem 'chromedriver-helper'
      gem 'launchy'
      gem 'rails-controller-testing'
    end
    CODE
          end

          insert_into_file 'Gemfile', after: "group :development, :test do\n" do <<-CODE
      gem 'faker'
      gem 'yard'
      gem 'letter_opener'
      gem "rails-erd"
    CODE
          end

          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
    gem 'haml-rails'
    gem "ransack"
    gem 'will_paginate'
    gem "font-awesome-rails"
    gem 'trix'
    gem 'record_tag_helper'
    gem 'jquery-rails'
    CODE
            end
            run 'bundle install'

            insert_into_file 'app/controllers/application_controller.rb', before: 'end' do <<-CODE
      private
    CODE
            end
          end

        # desc "Something", "Something cool"
        # def something
        #   # ...
        # end

      end
    end
  end
end
