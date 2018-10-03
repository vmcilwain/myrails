module Engine
  module Generators
    def self.included(thor)
      thor.class_eval do
        
        desc 'engine <OPTION> <NAME>', 'Execute without options to see HELP. Generate and configure a rails engine'
        def engine(*opts)
          item = opts[0]
          
          file = Dir['*.gemspec'].first
          
          @name = if file
                    File.basename(file, '.gemspec') 
                  else
                    opts[1]
                  end
                  
          option = {
            # base_install: 'Generate a new mountable rails engine with a set of gems and a rake and rspec default configuration',
            auto_setup: 'Run all of the setup options listed',
            engine_setup: 'Generate default configuration in Rails::Engine. <NAME> is the name used to generate the engine.',
            gemspec_setup: 'Setup gempsec file with default information. <NAME> is the name used to generate the engine.',
            new: 'Generate clean a full or mountable rails gem',
            rake_setup: 'Setup rake to run rspec as the default test framework along with other configs',
            rspec_setup: 'Configure RSpec to work with a rails engine'
          }
          
          unless item
            say 'ERROR: "myrails engine" was called with no arguments'
            say 'Usage: "myrails engine <OPTION> <NAME>"'
            say "Available Options:\n"
            option.each{|k,v| say "* #{k}: #{v}"}
            exit
          end
          
          raise ArgumentError, "NAME must be specified for #{item} option. Ex: `myrails engine <OPTION> <NAME>`" unless @name
          
          case item
          # when 'base_install'
          #   base_install
          when 'auto_setup'
            auto_setup
          when 'engine_setup'
            engine_setup
          when 'gem_setup'
            gem_setup
          when 'gemspec_setup'
            gemspec_setup
          when 'new'
            new_engine
          when 'rake_setup'
            rake_setup
          when 'rspec_setup'
            rspec_setup
          else
            say "Unknown Action! #{@name}"
          end
        end
        
      end
    end
  end
end