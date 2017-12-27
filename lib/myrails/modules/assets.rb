module Install
  module Assets
    def self.included(thor)
      thor.class_eval do

        def install_assets
          run "rm app/assets/stylesheets/application.css"
          copy_file 'rails/app/assets/stylesheets/application.css.sass', 'app/assets/stylesheets/application.css.sass'
          copy_file 'rails/app/assets/javascripts/application.js', 'app/assets/javascripts/application.js'
          copy_file 'rails/app/assets/stylesheets/animate.scss', 'app/assets/stylesheets/animate.scss'
          copy_file 'rails/app/assets/stylesheets/will_paginate.scss', 'app/assets/stylesheets/will_paginate.scss'
        end
        
      end
    end
  end
end
