require 'thor'
require 'active_support/all'
require_relative "../lib/myrails/version"
require_relative 'myrails/modules/gems'
require_relative 'myrails/modules/bootstrap'
require_relative 'myrails/modules/material'
require_relative 'myrails/modules/ui'
require_relative 'myrails/modules/assets'
require_relative 'myrails/modules/application'
require_relative 'myrails/modules/capistrano'
require_relative 'myrails/modules/database'
require_relative 'myrails/modules/devise'
require_relative 'myrails/modules/dotenv'
require_relative 'myrails/modules/engine'
require_relative 'myrails/modules/figaro'
require_relative 'myrails/modules/footnotes'
require_relative 'myrails/modules/heroku'
require_relative 'myrails/modules/pundit'
require_relative 'myrails/modules/rails_generators'
require_relative 'myrails/modules/rspec_generators'
require_relative 'myrails/modules/rspec'
module Myrails
  class Myrails < Thor
    include Thor::Actions
    source_root "#{__dir__}/myrails/templates"
    TEMPLATES = source_root
    ENVIRONMENTS = %w(development test production)

    no_tasks do
      include Install::Gems
      include Install::Ui
      include Install::ApplicationHelper
      include Install::RSpec
      include Install::Devise
      include Install::Pundit
      include Install::Footnotes
      include Install::DotEnv
      include Install::Heroku
      include Install::Capistrano
      include Install::Assets
      include Install::Figaro
      include Layout::Bootstrap
      include Layout::Material

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
        install_css
        install_footer
        install_ui
        install_pundit
        install_rspec
        install_footnotes
        config_env
        install_figaro
        git_init
        say 'Dont forget to run config_env'
      end

    end
    # end of no_tasks
    include Rails::Generators
    include RSpec::Generators
    include Rails::Engines
    include Rails::Database

    desc 'install NAME', 'Install customizations to convfigure application quickly. Type `myrails install` for options'
    def install(name=nil)
      options = {
        application_helper: 'Overwrite default application helper with a custom helper',
        gems: 'Install default gem set',
        layout: 'Generate assets and custom styles using either Boostrap or Material',
        ui: 'Generate UI resource',
        pundit: 'Install and configure Pundit gem',
        rspec: 'Install and configure Rspec gem',
        footnotes: 'Install and configure Footnotes gem',
        base: 'Run through all options listed in this list',
        git: 'Generate git directory and ignore default files',
        heroku: 'Generate needed setup for Heroku deployment',
        devise: 'Generate and configure Devise gem',
        dotenv: 'Generate and configure Dotenv gem (Do not use if figaro is already installed)',
        capistrano: 'Generate capistrano with default deployment',
        figaro: 'Generate and configure Figaro Gem (Do not use if dotenv is already installed)',
        env_config: 'Configure environment files with default hosts etc.'
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
      when 'footnotes'
        install_footnotes
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
      else
        say "Unknown Action!"
      end
    end

  end
end

Myrails::Myrails.start(ARGV)
