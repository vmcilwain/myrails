module Install
  module Ui
    def self.included(thor)
      thor.class_eval do
        desc 'install_ui', 'Generate UI route, controller and view setup'
        def install_ui
          copy_file 'ui/ui_controller.rb', 'app/controllers/ui_controller.rb'
          copy_file 'ui/index.html.haml', 'app/views/ui/index.html.haml'
          inject_into_file 'config/routes.rb', after: "Rails.application.routes.draw do\n" do <<-CODE
# Requires an application restart everytime a new page is added.
Dir.glob('app/views/ui/*.html.haml').sort.each do |file|
  action = File.basename(file,'.html.haml')
  get \"ui/\#{action}\", controller: 'ui', action: action
end
CODE
          end
        end

      end
    end
  end
end
