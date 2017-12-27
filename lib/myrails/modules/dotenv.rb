module Install
  module DotEnv
    def self.included(thor)
      thor.class_eval do

        desc 'install_dotenv', 'Install dotenv gem'
        def install_dotenv
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
  gem 'dotenv-rails', groups: [:development, :test]
  CODE
          end

          run 'bundle install'

          inject_into_file 'config.ru', after: "require_relative 'config/environment'\n" do <<-CODE
  require 'dotenv'
  Dotenv.load
  CODE
          end
          copy_file 'rails/env.config', '.env.development'
          copy_file 'rails/env.config', '.env.test'
          run 'touch .env.production'
        end

      end
    end
  end
end
