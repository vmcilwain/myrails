module Rails
  module Generators
    # ENVIRONMENTS = %w(development test production)
    
    def self.included(thor)
      thor.class_eval do
        desc 'kickstart <OPTION> <NAME>', 'Execute without options to see HELP. Generate a rails template with a given name'
        def kickstart(*opts)
          item, @name = opts
          
          option = {
            controller: 'Generate rails controller with corresponding RSpec file',
            decorator: 'Generate draper decorator with corresponding RSpec file',
            factory: 'Generate factory[girl|bot] factory',
            model: 'Generate rails model with corresponding RSpec file',
            policy: 'Generate pundit policy with corresponding RSpec file',
            ui: 'Generate a ui file for mocking front end'
          }
          
          unless item
            say 'ERROR: "myrails kickstart" was called with no arguments'
            say 'Usage: "myrails kickstart <OPTION> <NAME>"'
            say "Available Options:\n"
            option.each{|k,v| say "* #{k}: #{v}"}
            exit
          end
          
          raise ArgumentError, "NAME must be specified for #{item} option. Ex: `myrails kickstart <OPTION> <NAME>`" unless @name
          
          case item
          when 'model'
            model
          when 'controller'
            controller
          when 'policy'
            policy
          when 'ui'
            new_ui
          when 'policy'
            policy
          when 'decorator'
            decorator
          when 'factory'
            factory
          else
            say "Unknown Action! #{@name}"
          end
        end
        
        desc 'ks', 'Kickstart shortcut'
        alias_method :ks, :kickstart
        
      end # end thor.class_eval
    end # end self.included
  end # end module Generators
end # end module Rails
