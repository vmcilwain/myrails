module Install
  module DotEnv
    def self.included(thor)
      thor.class_eval do
        
        desc 'add_dotenv_gem', 'Add dotenv gem to Gemfile and run bundler'
        def add_dotenv_gem
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'dotenv-rails', groups: [:development, :test]
CODE
          end

          run 'bundle install'
        end
        
        desc 'require_dotenv', 'Add dotenv to config.ru'
        def require_dotenv
          inject_into_file 'config.ru', after: "require_relative 'config/environment'\n" do <<-CODE
  require 'dotenv'
  Dotenv.load
  CODE
          end
        end
        
        desc 'create_dev_dotenv', 'Generate deveopment env file'
        def create_dev_dotenv
          copy_file 'rails/env.config', '.env.development'
        end
        
        desc 'create_test_dotenv', 'Generate test env file'
        def create_test_dotenv
          copy_file 'rails/env.config', '.env.test'
        end
        
        desc 'create_prod_dotenv', 'Generate production env file'
        def create_prod_dotenv
          run 'touch .env.production'
        end
        
        desc 'setup_dotenv', 'Install dotenv gem'
        def setup_dotenv
          add_dotenv_gem
          require_dotenv
          create_dev_dotenv
          create_test_dotenv
          create_prod_dotenv
        end

      end
    end
  end
end
