module Install
  module Heroku
    def self.included(thor)
      thor.class_eval do

      desc 'install_heroku', 'setup application for use with heroku using sqlite3 for development'
      def install_heroku
        insert_into_file 'Gemfile', before: "group :development, :test do\n" do <<-CODE
group :production do
  gem 'pg'
  gem 'rails_12factor'
end

CODE
          end
          copy_file 'db/sqlite3_database.yml', 'config/database.yml'
          copy_file 'heroku/Procfile', 'Procfile'
          copy_file 'heroku/puma.rb', 'config/puma.rb'
      end

      end
    end
  end
end
