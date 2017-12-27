module Install
  module ApplicationHelper
    def self.included(thor)
      thor.class_eval do

        desc 'install_application_helper', 'Replace current application helper with one that has commonly used code'
        def install_application_helper
          copy_file 'rails/app/helpers/application_helper.rb', 'app/helpers/application_helper.rb'
        end

      end
    end
  end
end
