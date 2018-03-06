module RSpec
  module Generators
    def self.included(thor)
      thor.class_eval do

        desc 'shared_example', 'Generates an RSpec shared example template in the support directory'
        option :text, required: true
        def shared_example
          template 'spec/shared_example.rb', 'spec/support/shared_examples/shared_examples.rb'
        end

        desc 'request', 'Generates an RSpec request spec'
        option :name, required: true
        def request
          template 'spec/request.rb', "spec/requests/#{options[:name]}_spec.rb"
          copy_file 'spec/request_shared_example.rb', 'spec/support/shared_examples/request_shared_examples.rb'
        end

        desc 'feature', 'Generates an RSpec feature spec'
        option :name, required: true
        def feature
          copy_file 'spec/feature.rb', "spec/features/#{options[:name]}_spec.rb"
        end

        desc 'helper', 'Generates an RSpec helper in support/helpers for extracting reusable code'
        long_desc <<-LONGDESC
        `myrails helper` will generate an RSpec helper module to use with rspec.

        You can optionally specify a type parameter which will only include the module for the given type of spec.

        > $ myrails helper --name article --type :feature
        LONGDESC
        option :name, required: true
        option :type
        def helper
          template 'spec/helper.rb', "spec/support/helpers/#{options[:name].downcase.gsub("\s", '_')}.rb"
          insert_into_file 'spec/rails_helper.rb', after: "RSpec.configure do |config|\n" do <<-CODE
        config.include #{options[:name].camelize.gsub("\s", '')}Helper#{", type: #{options[:type]}" if options[:type]}
        CODE
          end
        end

      end
    end
  end
end
