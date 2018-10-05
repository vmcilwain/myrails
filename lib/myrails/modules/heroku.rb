module Install
  module Heroku
    def self.included(thor)
      thor.class_eval do

        desc 'add_heroku_gems', 'Add gems for heroku to Gemfile'
        def add_heroku_gems
          insert_into_file 'Gemfile', before: "group :development, :test do\n" do <<-CODE
  group :production do
    gem 'pg'
    gem 'rails_12factor'
  end

  CODE
          run 'bundle install'
        end
        
        desc 'create_sqlite3_config', 'Generate SQLITE3 database config'
        def create_sqlite3_config
          copy_file 'db/sqlite3_database.yml', 'config/database.yml'
        end
        
        desc 'create_heroku_procfile', 'Generate a procfile for use with heroku'
        def create_heroku_procfile
          copy_file 'heroku/Procfile', 'Procfile'
        end
        
        desc 'create_heroku_puma_config', 'Generate a puma config for use with heroku'
        def create_heroku_puma_config
          copy_file 'heroku/puma.rb', 'config/puma.rb'
        end
        
        desc 'install_heroku', 'setup application for use with heroku using sqlite3 for development'
        def setup_heroku
          add_heroku_gems
          create_sqlite3_config
          create_heroku_procfile
          create_heroku_puma_config
        end

      end
    end
  end
end
