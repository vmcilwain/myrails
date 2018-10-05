module Install
  module Figaro
    def self.included(thor)
      thor.class_eval do
        
        desc 'add_figaro', 'Add Figaro gem to Gemfile and run bundler'
        def add_figaro
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
  gem "figaro"
  CODE
          end

          run 'bundle install'
        end
        
        desc 'generate_figaro', 'Run Figaro installer'
        def generate_figaro
          run 'bundle exec figaro install'
        end
        
        desc 'generate_example', 'Create example application.yml file'
        def generate_example
          copy_file 'rails/config/application.example.yml', 'config/application.example.yml'
        end
        
        desc 'setup_figaro', 'Install and configure figaro gem'
        def setup_figaro
          add_figaro
          generate_figaro
          generate_example
        end

      end
    end
  end
end
