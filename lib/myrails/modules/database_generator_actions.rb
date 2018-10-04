module Database
  module Generator
    module Actions
      def self.included(thor)
        thor.class_eval do
          
          desc 'mysql_switch', 'Convert a rails database configuration from sqlite3 to mysql2'
          def mysql_switch
            gsub_file 'Gemfile', "gem 'sqlite3'", "gem 'mysql2'"
            run 'bundle install'
            copy_file 'db/mysql_database.yml', 'config/database.yml'
          end
          
        end
      end
    end
  end
end