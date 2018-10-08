module Rails
  module Generator
    module Actions
      
      ENVIRONMENTS = %w(development test production)
      
      def self.included(thor)
        
        thor.class_eval do
          
          desc 'model', "Generates a rails model with the given name along with its related spec file and namespace prefix for table creation. Use '/' to create a namespaced model"
          def model
            template 'rails/app/models/model.rb', "app/models/#{@name.downcase}.rb"
            template 'rails/app/models/namespace_model.rb', "app/models/#{@name.split("/").first.singularize.downcase}.rb" if @name.include?("/")
            template 'spec/model.rb', "spec/models/#{@name.downcase}_spec.rb"
          end

          desc 'controller', "Generates a rails controller with the given name along with related spec file. Use '/' to create a namespaced controller"
          def controller
            template 'rails/app/controllers/controller.rb', "app/controllers/#{@name.downcase.pluralize}_controller.rb"
            if @name.include?("/")
              parent, child = name.split("/")
              template 'rails/app/controllers/namespace_controller.rb', "app/controllers/#{parent}/#{parent.downcase}_controller.rb"
            end
            
            template 'spec/controller.rb', "spec/controllers/#{@name.downcase.pluralize}_controller_spec.rb"
            run "mkdir -p app/views/#{@name.downcase.pluralize}"
          end

          desc 'policy', "Generates a pundit policy with the given name and a related spec file. Use '/' to create a namespaced policy"
          def policy
            template 'rails/app/policies/pundit.rb', "app/policies/#{@name.downcase}_policy.rb"
            template 'spec/pundit.rb', "spec/policies/#{@name.downcase}_policy_spec.rb"
          end
        
          desc 'decorator', 'Generates draper decoration with given name and related spec file'
          def decorator
            copy_file 'rails/app/decorators/application_decorator.rb', 'app/decorators/application_decorator.rb'
            template 'rails/app/decorators/decoration.rb', "app/decorators/#{@name.downcase}_decoration.rb"
            copy_file 'spec/support/configs/decorator_presenter.rb', 'spec/support/configs/decorator_presenter.rb'
            template 'spec/decorator_spec.rb', "spec/decorators/#{@name.downcase}_decorator_spec.rb"
          end
        
          desc 'factory', "Generates a factory_bot factory in the spec/factories directory. Use '/' to create a namespaced factory"
          def factory
            template 'spec/factory.rb', "spec/factories/#{@name.downcase}.rb"
          end

          desc 'config_env', 'Add code to environment files. Host refers to url options. Name option referes to controller and mailer default_url_options'
          def config_env
            ENVIRONMENTS.each do |environment|
              case environment
              when 'development'
                inject_into_file 'config/environments/development.rb', after: "config.action_mailer.raise_delivery_errors = false\n" do <<-CODE
      config.action_mailer.delivery_method = :letter_opener
      config.action_mailer.perform_deliveries = false
      config.action_mailer.default_url_options = { host: ENV.fetch('DEFAULT_HOST') }
      config.action_controller.default_url_options = { host: ENV.fetch('DEFAULT_HOST') }
      CODE
                end
              when 'test'
                inject_into_file 'config/environments/test.rb', after: "config.action_mailer.delivery_method = :test\n" do <<-CODE
      config.action_mailer.default_url_options = { host: ENV.fetch('DEFAULT_HOST') }
      config.action_controller.default_url_options = { host: ENV.fetch('DEFAULT_HOST') }
      CODE
                end
              when 'production'
                inject_into_file 'config/environments/production.rb', after: "config.active_record.dump_schema_after_migration = false\n" do <<-CODE
      config.action_mailer.default_url_options = { host: ENV.fetch('DEFAULT_HOST') }
      config.action_controller.default_url_options = { host: ENV.fetch('DEFAULT_HOST') }
      config.assets.compile = true
      CODE
                end
              end
            end
          end

          desc 'new_ui NAME', 'Create a new ui view'
          def new_ui
            run "touch app/views/ui/#{@name.downcase}.html.haml"
            say "DON'T FORGET: Restart the rails app"
          end
          
        end
        
      end
      
    end
  end
end



#         desc 'presenter', "Generates a presenter class with the given name and a related spec file. Use '/' to create a namespaced presenter"
#         option :name, required: true
#         def presenters
#           inject_into_file 'app/helpers/application_helper.rb', after: "module ApplicationHelper\n" do <<-CODE
#   def present(object, klass = nil)
#     klass ||= "#{object.class}Presenter".constantize
#     presenter = klass.new(object, self)
#     yield presenter if block_given?
#     presenter
#   end
#
# CODE
#           copy_file 'rails/app/presenters/base.rb', 'app/presenters/base_presenter.rb'
#           template 'rails/app/presenters/presenter.rb', "app/presenters/#{options[:name].downcase}_presenter.rb"
#           copy_file 'spec/support/configs/decorator_presenter.rb', 'spec/support/configs/decorator_presenter.rb'
#           template 'rails/app/presenters/presenter_spec.rb', "spec/presenters/#{options[:name].downcase}_presenter_spec.rb"
#         end