module Application
  module Generator
    module Actions
      def self.included(thor)
        thor.class_eval do

          def install_application_helper
            copy_file 'rails/app/helpers/application_helper.rb', 'app/helpers/application_helper.rb'
          end
        
          desc 'install_layout', 'Generate common layout files'
          def install_layout
            answer = ask 'Would you like to use [B]ootstrap or [M]aterial'

            run 'rm app/views/layouts/application.html.erb'

            install_assets

            if answer =~ /^B|b/
              install_bootstrap
            elsif answer =~ /^M|m/
              install_material
            end

            insert_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::Base\n" do <<-CODE
      add_flash_types :error, :success
    CODE
            end
          end
        
          desc 'git_init', "Initialize git with some files automatically ignored"
          def git_init
            run 'git init'
            run 'echo /coverage >> .gitignore'
            run 'echo /config/application.yml >> .gitignore'
            run 'git add --all'
            run "git commit -m 'initial commit'"
          end
        
          desc 'base_install', 'Run the most common actions in the right order'
          def base_install
            install_gems
            install_application_helper
            install_assets
            install_layout
            install_ui
            install_pundit
            install_draper
            install_rspec
            config_env
            install_figaro
            git_init
            say 'Dont forget to run setup config/application.yml with initial values.'
          end

          desc 'install_sendgrid', 'Generate sendgrid initializer and mail interceptor'
          def install_sendgrid
            environments = %w(development test production)
        
            @email = ask('What email address would you like to use?')
        
            raise ArgumentError, 'Email address required' unless @email
        
            copy_file 'rails/app/mailers/sendgrid.rb', 'config/initializers/sendgrid.rb'
            template 'rails/app/mailers/dev_mail_interceptor.rb', 'app/mailers/dev_mail_interceptor.rb'
            environments.each do |environment|
              unless environment == 'production'
                inject_into_file "config/environments/#{environment}.rb", after: "Rails.application.configure do\n" do <<-CODE
        ActionMailer::Base.register_interceptor(DevMailInterceptor)
                  CODE
                end
              end
            end
          end
        
        end
      end
    end
  end
end
