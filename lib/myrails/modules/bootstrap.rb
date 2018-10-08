module Layout
  module Bootstrap
    
    def self.included(thor)
      thor.class_eval do
        
        desc 'choose_bootstrap_theme', 'Select a bootswatch.com bootstrap theme'
        def choose_bootstrap_theme
          themes = Dir[File.join("#{__dir__}", '..', 'templates', 'rails', 'app','assets', 'stylesheets', 'bootstrap', 'bootstrap_themes', '*')]

          themes.each_with_index do |theme, index|
            say "[#{index}] #{File.basename(theme,'.*')}"
          end

          idx = ask "Choose a color theme (by number) for the application. Default: ", :yellow, 
          default: themes.index{|theme| theme if theme.include?('spacelab')}

          copy_file(themes[idx], "app/assets/stylesheets/#{File.basename(themes[idx])}")

          inject_into_file 'app/assets/stylesheets/application.css.sass', before: "@import will_paginate" do <<-CODE
@import #{File.basename(themes[idx], '.*')}
    CODE
          end
        end

        desc 'choose_bootstrap_footer', 'Select a bootstrap footer template'
        def choose_bootstrap_footer
          footers = Dir[File.join("#{__dir__}", '..', 'templates', 'rails', 'app', 'views','layout', 'bootstrap', 'footers', '*.haml')]
          footers_css = Dir[File.join("#{__dir__}", '..', 'templates', 'rails', 'app', 'views', 'layout', 'bootstrap', 'footers', 'css', '*')]

          footers.each_with_index do |footer, index|
            say "[#{index}] #{File.basename(footer,'.html.*')}"
          end

          idx = ask "Chose a footer theme (by number) for the application. Deault: ", :yellow, default: footers.index{|footer| footer if footer.include?('footer-distributed.html.haml')}

          copy_file footers[idx], "app/views/layouts/_footer.html.haml"
          copy_file footers_css[idx], "app/assets/stylesheets/#{File.basename(footers_css[idx])}"

          inject_into_file 'app/assets/stylesheets/application.css.sass', after: "@import animate\n" do <<-CODE
@import #{File.basename(footers_css[idx], '.*')}
    CODE
          end
        end
        
        desc 'copy_bootstrap_files', 'generate layout navigation and flash messages'
        def copy_bootstrap_files
          template 'rails/app/views/layout/bootstrap/application.html.haml', 'app/views/layouts/application.html.haml'
          template 'rails/app/views/layout/bootstrap/_nav.html.haml', 'app/views/layouts/_nav.html.haml'
          copy_file 'rails/app/views/layout/bootstrap/_info_messages.html.haml', 'app/views/layouts/_info_messages.html.haml'
          copy_file 'rails/app/views/layout/bootstrap/_success_message.html.haml', 'app/views/layouts/_success_message.html.haml'
          copy_file 'rails/app/views/layout/bootstrap/_error_messages.html.haml', 'app/views/layouts/_error_messages.html.haml'
        end

        desc 'setup_bootstrap', 'Generate layout using Bootrap CSS Framework'
        def setup_bootstrap

          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'bootstrap-sass', '~> 3.3.1'
gem 'autoprefixer-rails'
CODE
          end

          insert_into_file 'app/assets/stylesheets/application.css.sass', before: '@import trix' do <<-CODE
@import bootstrap-sprockets
@import bootstrap
    CODE
          end

          insert_into_file 'app/assets/javascripts/application.js', before: '//= require trix' do <<-CODE
  //= require bootstrap-sprockets
  CODE
          end
          
          run 'bundle install'
          choose_bootstrap_theme
          choose_bootstrap_footer
          copy_bootstrap_files

        end
      end
    end
  end
end
