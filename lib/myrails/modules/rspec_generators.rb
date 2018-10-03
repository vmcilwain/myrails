module RSpec
  module Generators
    def self.included(thor)
      thor.class_eval do
        
        desc 'spec <OPTION> <NAME>', 'Execute without options to see HELP. Generate a rspec template with a given name'
        def spec(*opts)
          item, @param = opts
          
          option = {
            example: 'Generate RSpec shared example temlate. Prompts for name and context',
            feature: 'Generate RSpec feature template',
            helper: 'Generates an RSpec helper in support/helpers for extracting reusable code',
            request: 'Generate RSpec request template'
          }
          
          unless item
            say 'ERROR: "myrails spec" was called with no arguments'
            say 'Usage: "myrails spec <OPTION> <NAME>"'
            say "Available Options:\n"
            option.each{|k,v| say "* #{k}: #{v}"}
            exit
          end
          
          raise ArgumentError, "NAME must be specified for #{item} option. Ex: `myrails spec <OPTION> <NAME>`" unless @param
          
          case item
          when 'example'
            shared_example
          when 'feature'
            feature
          when 'helper'
            helper
          when 'request'
            request
          else
            say "Unknown Action! #{@param}"
          end
        end

      end
    end
  end
end
