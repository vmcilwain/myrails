module Application
  module Generator
    module Actions
      def self.included(thor)
        thor.class_eval do
          
          desc 'setup_application_helper', 'overwrite rails application helper with some default code'
          def setup_application_helper
            copy_file 'rails/app/helpers/application_helper.rb', 'app/helpers/application_helper.rb'
          end
        
          desc 'setup_layout', 'Generate JS and CSS files with a choice of CSS Framework'
          def setup_layout
            answer = ask 'Would you like to use [B]ootstrap or [M]aterial? Default: ', :yellow, default: 'M'

            run 'rm app/views/layouts/application.html.erb'

            setup_assets

            if answer =~ /^B|b/
              setup_bootstrap
            elsif answer =~ /^M|m/
              setup_material
            end

            insert_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do <<-CODE
      add_flash_types :error, :success
    CODE
            end
          end
        
          desc 'setup_git', "Initialize git with some files set to be ignored"
          def setup_git
            run 'git init' unless File.exist?('.git')
            run 'echo /coverage >> .gitignore'
            run 'echo /config/application.yml >> .gitignore'
            run 'git add --all'
            run "git commit -m 'initial commit'"
          end
        
          desc 'base_setup', 'Run the most common setup actions in the right order'
          def base_setup
            setup_gems
            setup_application_helper
            setup_layout
            setup_ui
            setup_pundit
            setup_draper
            setup_rspec
            config_env
            setup_figaro
            setup_git
            say 'Dont forget to run setup config/application.yml with initial values.'
          end

        
        end
      end
    end
  end
end
