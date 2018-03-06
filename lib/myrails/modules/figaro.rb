module Install
  module Figaro
    def self.included(thor)
      thor.class_eval do

        def install_figaro
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
  gem "figaro"
  CODE
          end

          run 'bundle install'
          run 'bundle exec figaro install'
          copy_file 'rails/config/application.example.yml', 'config/application.example.yml'
        end

      end
    end
  end
end
