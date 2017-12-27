module Layout
  module Material
    def self.included(thor)
      thor.class_eval do
        def copy_material_files
          Dir["#{__dir__}/myrails/templates/rails/app/views/layout/material/**/*"].each do |file|
            copy_file file, "app/views/layouts/#{File.basename(file)}"
          end
        end

        desc 'install_material', 'Generate Material css theme'
        def install_material
          @templates = "#{__dir__}/../templates"
          
          insert_into_file 'Gemfile', after: "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]\n" do <<-CODE
    gem 'materialize-sass'
    gem 'material_icons'
    CODE
          end

          run 'bundle install'

          copy_material_files

          insert_into_file 'app/assets/stylesheets/application.css.sass', before: '@import trix' do <<-CODE
  @import "materialize/components/color"
  $primary-color: color("grey", "darken-3") !default
  $secondary-color: color("grey", "base") !default
  @import materialize
  @import material_icons
  CODE
          end

          insert_into_file 'app/assets/javascripts/application.js', before: "//= require trix" do <<-CODE
  //= require materialize
  CODE
          end
        end

      end
    end
  end
end
