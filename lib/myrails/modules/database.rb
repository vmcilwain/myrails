module Rails
  module Database
    def self.included(thor)
      thor.class_eval do

        def mysql_switch
          gsub_file 'Gemfile', "gem 'sqlite3'", "gem 'mysql2', '>= 0.3.13', '< 0.5'"
          run 'bundle install'
          copy_file 'db/mysql_database.yml', 'config/database.yml'
        end

      end
    end
  end
end