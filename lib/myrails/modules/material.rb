module Layout
  module Material
    TEMPLATES = "#{__dir__}/../templates" # double check if I need this
    def self.included(thor)
      thor.class_eval do
        desc 'generate_material_files', 'Generate material layout files'
        def generate_material_files
          Dir["#{__dir__}/../templates/rails/app/views/layout/material/**/*"].each do |file|
            copy_file file, "app/views/layouts/#{File.basename(file)}"
          end
        end
        
        desc 'add_material_gem', 'Add materialize sass and icons gem to Gemfile and run bundler'
        def add_material_gem
          # @templates = "#{__dir__}/../templates"

          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
gem 'materialize-sass'
gem 'material_icons'
CODE
          end

          run 'bundle install'
        end
        
        desc 'setup_application_sass', 'add materialize to sass manifest'
        def setup_materialize_css
          insert_into_file 'app/assets/stylesheets/application.css.sass', before: '@import trix' do <<-CODE
@import "materialize/components/color"
$primary-color: color("grey", "darken-3") !default
$secondary-color: color("grey", "base") !default
@import materialize
@import material_icons
CODE
          end
        end
        
        desc 'add_materialize_js', 'add materialize to js manifest'
        def setup_materialize_js
          insert_into_file 'app/assets/javascripts/application.js', before: "//= require trix" do <<-CODE
//= require materialize
  CODE
          end
        end
        desc 'install_material', 'Generate Material css theme'
        def setup_material
          generate_material_files
          setup_materialize_css
          setup_materialize_js
        end

      end
    end
  end
end
