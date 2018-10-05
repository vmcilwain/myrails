module Install
  module Ui
    def self.included(thor)
      thor.class_eval do
        
        desc 'generate_ui_controller', 'Generate the ui controller'
        def generate_ui_controller
          copy_file 'ui/ui_controller.rb', 'app/controllers/ui_controller.rb'
        end
        
        desc 'generate_index', 'Generate index view'
        def generate_index
          copy_file 'ui/index.html.haml', 'app/views/ui/index.html.haml'
        end
        
        desc 'setup_route', 'Add route code to routes config'
        def setup_route
          inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-CODE
# Requires an application restart everytime a new page is added.
Dir.glob('app/views/ui/*.html.haml').sort.each do |file|
  action = File.basename(file,'.html.haml')
  get \"ui/\#{action}\", controller: 'ui', action: action
end
CODE
          end
        end
        
        desc 'setup_ui', 'Generate UI route, controller and view setup'
        def setup_ui
          generate_ui_controller
          generate_index
          setup_ui
        end

      end
    end
  end
end
