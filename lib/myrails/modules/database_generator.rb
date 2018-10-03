module Database
  module Generators
    def self.included(thor)
      thor.class_eval do
        
        desc 'db <OPTION>', 'Execute without options to see HELP.'
        def db(*opts)
          item = opts[0]
                  
          option = {
            mysql_switch: 'Switch DB from SQLITE3 to MySQL'
          }
          
          unless item
            say 'ERROR: "myrails db" was called with no arguments'
            say 'Usage: "myrails db <OPTION> <NAME>"'
            say "Available Options:\n"
            option.each{|k,v| say "* #{k}: #{v}"}
            exit
          end
          
          case item
          when 'mysql_switch:'
            mysql_switch
          else
            say "Unknown Action!"
          end
        end
        
      end
    end
  end
end
