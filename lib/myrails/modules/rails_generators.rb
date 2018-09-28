module Rails
  module Generators
    ENVIRONMENTS = %w(development test production)
    def self.included(thor)
      thor.class_eval do

        desc 'model', "Generates a rails model with the given name along with its related spec file and namespace prefix for table creation. Use '/' to create a namespaced model"
        option :name, required: true
        def model
          template 'rails/app/models/model.rb', "app/models/#{options[:name].downcase}.rb"
          template 'rails/app/models/namespace_model.rb', "app/models/#{options[:name].split("/").first.singularize.downcase}.rb" if options[:name].include?("/")
          template 'spec/model.rb', "spec/models/#{options[:name].downcase}_spec.rb"
        end

        desc 'controller', "Generates a rails controller with the given name along with related spec file. Use '/' to create a namespaced controller"
        option :name, required: true
        def controller
          template 'rails/app/controllers/controller.rb', "app/controllers/#{options[:name].downcase.pluralize}_controller.rb"
          if options[:name].include?("/")
            parent, child = options[:name].split("/")
            template 'rails/app/controllers/namespace_controller.rb', "app/controllers/#{parent}/#{parent.downcase}_controller.rb"
          end
          template 'spec/controller.rb', "spec/controllers/#{options[:name].downcase.pluralize}_controller_spec.rb"
          run "mkdir -p app/views/#{options[:name].downcase.pluralize}"
        end

        desc 'policy', "Generates a pundit policy with the given name and a related spec file. Use '/' to create a namespaced policy"
        option :name, required: true
        def policy
          template 'rails/app/policies/pundit.rb', "app/policies/#{options[:name].downcase}_policy.rb"
          template 'spec/pundit.rb', "spec/policies/#{options[:name].downcase}_policy_spec.rb"
        end

        desc 'presenter', "Generates a presenter class with the given name and a related spec file. Use '/' to create a namespaced presenter"
        option :name, required: true
        def presenters
          copy_file 'rails/app/presenters/base.rb', 'app/presenters/base_presenter.rb'
          template 'rails/app/presenters/presenter.rb', "app/presenters/#{options[:name].downcase}_presenter.rb"
          copy_file 'rails/app/presenters/presenter_config.rb', 'spec/support/configs/presenter.rb'
          template 'rails/app/presenters/presenter_spec.rb', "spec/presenters/#{options[:name].downcase}_presenter_spec.rb"
        end

        desc 'factory', "Generates a factory_bot factory in the spec/factories directory. Use '/' to create a namespaced factory"
        option :name, required: true
        def factory
          template 'spec/factory.rb', "spec/factories/#{options[:name].downcase}.rb"
        end

        desc 'sendgrid', 'Generate sendgrid initializer and mail interceptor'
        option :email, required: true
        def sendgrid
          copy_file 'rails/app/mailers/sendgrid.rb', 'config/initializers/sendgrid.rb'
          template 'rails/app/mailers/dev_mail_interceptor.rb', 'app/mailers/dev_mail_interceptor.rb'
          ENVIRONMENTS.each do |environment|
            unless environment == 'production'
              inject_into_file "config/environments/#{environment}.rb", after: "Rails.application.configure do\n" do <<-CODE
      ActionMailer::Base.register_interceptor(DevMailInterceptor)
                CODE
              end
            end
          end
        end

        desc 'config_env', 'Add code to environment files. Host refers to url options. Name option referes to controller and mailer default_url_options'
        option :name, required: true
        def config_env
          ENVIRONMENTS.each do |environment|
            case environment
            when 'development'
              inject_into_file 'config/environments/development.rb', after: "config.action_mailer.raise_delivery_errors = false\n" do <<-CODE
    config.action_mailer.delivery_method = :letter_opener
    config.action_mailer.perform_deliveries = false
    config.action_mailer.default_url_options = { host: ENV['DEFAULT_HOST'] }
    config.action_controller.default_url_options = { host: ENV['DEFAULT_HOST'] }
    CODE
              end
            when 'test'
              inject_into_file 'config/environments/test.rb', after: "config.action_mailer.delivery_method = :test\n" do <<-CODE
    config.action_mailer.default_url_options = { host: ENV['DEFAULT_HOST'] }
    config.action_controller.default_url_options = { host: ENV['DEFAULT_HOST'] }
    CODE
              end
            when 'production'
              inject_into_file 'config/environments/production.rb', after: "config.active_record.dump_schema_after_migration = false\n" do <<-CODE
    config.action_mailer.default_url_options = { host: ENV['DEFAULT_HOST'] }
    config.action_controller.default_url_options = { host: ENV['DEFAULT_HOST'] }
    config.assets.compile = true
    CODE
              end
            end
          end
        end

        desc 'new_ui NAME', 'Create a new ui view'
        def new_ui(name)
          run "touch app/views/ui/#{name}.html.haml"
          say "DON'T FORGET: Restart Powify App"
        end

      end
    end
  end
end
