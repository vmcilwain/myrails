module Install
  module Draper
    def self.included(thor)
      thor.class_eval do
        desc 'install_draper', 'Install draper gem'
        def install_draper
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'draper'
CODE
          end
        
          run 'bundle install'
        
          copy_file 'rails/app/decorators/application_decorator.rb', 'app/decoratorators/application_decorator.rb'
        end
      end
    end
  end
end