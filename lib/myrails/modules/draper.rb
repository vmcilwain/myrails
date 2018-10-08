module Install
  module Draper
    def self.included(thor)
      thor.class_eval do
        
        desc 'add_draper_gem', 'Add draper gem to Gemfile and run bundler'
        def add_draper_gem
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'draper'
CODE
          end
        
          run 'bundle install'
        end
        
        desc 'create_draper_application_decorator', 'Generate draper application decorator'
        def create_draper_application_decorator
          copy_file 'rails/app/decorators/application_decorator.rb', 'app/decorators/application_decorator.rb'
        end
        
        desc 'setup_draper', 'Install draper gem'
        def setup_draper
          add_draper_gem
          create_draper_application_decorator
        end
      end
    end
  end
end