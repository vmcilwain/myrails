module Install
  module Footnotes
    def self.included(thor)
      thor.class_eval do

        desc 'install_footnotes', 'Install rails-footnotes and run its generator'
        def install_footnotes
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
  gem 'rails-footnotes'
  CODE
          end
          run 'bundle install'
          run 'rails generate rails_footnotes:install'
        end

      end
    end
  end
end
