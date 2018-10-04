module Application
  module Generators
    def self.included(thor)
      thor.class_eval do
        
        desc 'install NAME', 'Install customizations to configure application quickly. Type `myrails install` for options'
        def install(name=nil)
          options = {
            app_helper: 'Overwrite default application helper with a custom helper',
            base: 'Run through all options listed in this list',
            capistrano: 'Generate capistrano with default deployment',
            devise: 'Generate and configure Devise gem',
            dotenv: 'Generate and configure Dotenv gem (Do not use if figaro is already installed)',
            draper: 'Generate and configure Draper gem',
            env_config: 'Configure environment files with default hosts etc.',
            figaro: 'Generate and configure Figaro Gem (Do not use if dotenv is already installed)',
            gems: 'Install default gem set',
            git: 'Generate git directory and ignore default files',
            heroku: 'Generate needed setup for Heroku deployment',
            layout: 'Generate assets and custom styles using either Boostrap or Material',
            pundit: 'Install and configure Pundit gem',
            rspec: 'Install and configure Rspec gem',
            sendgrid: 'Install and configure ActionMailer to use sendgrid',
            ui: 'Generate UI resource'
          }
      
          unless name
            say 'ERROR: "myrails install" was called with no arguments'
            say 'Usage: "myrails install NAME"'
            say "Available Options:\n"
            options.each{|k,v| say "* #{k}: #{v}"}
            exit
          end

          case name
          when 'application_helper'
            install_application_helper
          when 'gems'
            install_gems
          when 'layout'
            install_layout
          when 'ui'
            install_ui
          when 'pundit'
            install_pundit
            install_rails_helper
          when 'rspec'
            install_rspec
          when 'base'
            base_install
          when 'git'
            git_init
          when 'heroku'
            install_heroku
          when 'devise'
            install_devise
          when 'dotenv'
            install_dotenv
          when 'capistrano'
            install_capistrano
          when 'figaro'
            install_figaro
          when 'env_config'
            config_env
          when 'draper',
            install_draper
          when 'sendgrid'
            install_sendgrid
          else
            say "Unknown Action! #{name}"
          end
        end
        
      end
    end
  end
end