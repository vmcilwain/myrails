module RSpec
  module Generator
    module Actions
      
      
      def self.included(thor)
        
        thor.class_eval do
          
          desc 'shared_example', 'Generates an RSpec shared example template in the support directory'
          def shared_example
            @description = ask("What is the NAME of shared example?, Ex: requires authorization:")
            @context = ask("What is the CONTEXT of the shared example?, Ex: authorized user:")
            
            template 'spec/shared_example.rb', "spec/support/shared_examples/#{@param.downcase.gsub("\s", '_')}_shared_examples.rb"
          end

          desc 'request', 'Generates an RSpec request spec'
          def request
            template 'spec/request.rb', "spec/requests/#{@param.downcase.gsub("\s", "_")}_spec.rb"
            copy_file 'spec/request_shared_example.rb', 'spec/support/shared_examples/request_shared_examples.rb'
          end

          desc 'feature', 'Generates an RSpec feature spec'
          def feature
            @description = ask("What is the description of feature?, Ex: user management:")
            @scenario = ask("What is the CONTEXT of the shared example?, Ex: as a user ...:")
            template 'spec/feature.rb', "spec/features/#{@param.downcase.gsub("\s", '_')}_spec.rb"
          end

          desc 'helper', 'Generates an RSpec helper in support/helpers for extracting reusable code'
          long_desc <<-LONGDESC
          `myrails helper` will generate an RSpec helper module to use with rspec.

          You can optionally specify a type parameter which will only include the module for the given type of spec.

          > $ myrails helper --name article --type :feature
          LONGDESC

          def helper
            @type = ask('what is the type? Ex: :feature, :controller, :request, :model :')
            template 'spec/helper.rb', "spec/support/helpers/#{@param.downcase.gsub("\s", '_')}.rb"
            insert_into_file 'spec/rails_helper.rb', after: "RSpec.configure do |config|\n" do <<-CODE
  config.include #{@param.camelize.gsub("\s", '')}Helper#{", type: #{':' unless @type.include?(':')}#{@type}" if @type}
CODE
            end
          end
          
        end
        
      end
      
    end
  end
end