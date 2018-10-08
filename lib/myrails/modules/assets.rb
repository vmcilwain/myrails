module Install
  module Assets
    def self.included(thor)
      thor.class_eval do
        
        desc 'remove_css_manifest', 'delete application.css stylesheet'
        def remove_css_manifest
          run "rm app/assets/stylesheets/application.css"
        end
        
        desc 'generate_sass_manifest', 'create applicatin.css.sass manifest'
        def generate_sass_manifest
          copy_file 'rails/app/assets/stylesheets/application.css.sass', 'app/assets/stylesheets/application.css.sass'
        end
        
        desc 'generate_js_manifest', 'create application.js manifest'
        def generate_js_manifest
          copy_file 'rails/app/assets/javascripts/application.js', 'app/assets/javascripts/application.js'
        end
        
        desc 'generate_animate_css', 'create animate.css file'
        def generate_animate_css
          copy_file 'rails/app/assets/stylesheets/animate.scss', 'app/assets/stylesheets/animate.scss'
        end
        
        desc 'generate_will_paginate', 'create will paginate css'
        def generate_will_paginate
          copy_file 'rails/app/assets/stylesheets/will_paginate.scss', 'app/assets/stylesheets/will_paginate.scss'
        end
        
        desc 'setup_assets', 'install CSS librarys and configure CSS & JS manifests'
        def setup_assets
          remove_css_manifest
          generate_sass_manifest
          generate_js_manifest
          generate_animate_css
          generate_will_paginate
        end
        
      end
    end
  end
end
