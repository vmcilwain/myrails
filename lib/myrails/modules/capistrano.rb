module Install
  module Capistrano
    def self.included(thor)
      thor.class_eval do
        
        desc 'add_capistrano_gems', 'Add campistrano to Gemfile and install'
        def add_capistrano_gems
          insert_into_file 'Gemfile', after: "group :development do\n" do <<-CODE
  gem 'capistrano', '~> 3.6', group: :development
  gem 'capistrano-rails', '~> 1.3', group: :development
  gem 'capistrano-rvm', group: :development
CODE
          end

          run 'bundle install'
        end
        
        desc 'configure_capfile', 'Add required libraries to capistrano capfile'
        def configure_capfile
          gsub_file 'Capfile', '# require "capistrano/rvm"', 'require "capistrano/rvm"'

          insert_into_file 'Capfile', after: "require \"capistrano/rvm\"\n" do <<-CODE
  require "capistrano/rails"
  CODE
          end
        end

        desc 'configure_deploy', 'Add default options to capistrano deploy file'
        def configure_deploy
          gsub_file 'config/deploy.rb', '# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp', 'ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp'
          gsub_file 'config/deploy.rb', '# set :deploy_to, "/var/www/my_app_name"', 'set :deploy_to, "/var/www/#{fetch(:application)}"'
          gsub_file 'config/deploy.rb', '# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"', 'append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"'

          insert_into_file 'config/deploy.rb', before: '# Default branch is :master' do <<-CODE
set :deploy_via, :remote_cache
set :ssh_options, {forward_agent: true}
  CODE
          end
        end

        desc 'copy_templates', 'Add capistrano templates used to manage the remote server'
        def copy_templates
          Dir[File.join("#{__dir__}", "..", "templates","capistrano","**","*")].each do |file|
            copy_file file, "#{file.gsub(__dir__+'/../templates/capistrano/', '')}" unless File.directory? file
          end
        end

        desc 'configure_env_files', 'Configure capistrano environemnt specific information'
        def configure_env_files
          insert_into_file 'config/deploy/production.rb', before: "# role-based syntax" do <<-CODE
set :fqdn,'domain.com'
  CODE
          end

          insert_into_file 'config/deploy/staging.rb', before: "# role-based syntax" do <<-CODE
set :fqdn,'domain.com'
  CODE
          end
        end

        desc 'add_tasks', 'Add custom deploy tasks to capistrano deploy file'
        def add_tasks
          insert_into_file 'config/deploy.rb', after: "# set :ssh_options, verify_host_key: :secure\n" do <<-CODE
  namespace :deploy do
    # after :restart, :clear_cache do
    #   on roles(:app), in: :groups, limit: 3, wait: 10 do
    #     # Here we can do anything such as:
    #     # within release_path do
    #     #   execute :rake, 'cache:clear'
    #     # end
    #   end
    # end
    before :finishing, :restart do
      on roles(:app) do
        invoke 'unicorn:restart'
        invoke 'nginx:restart'
      end
    end

    task :upload_app_yml do
      on roles(:app) do
        info 'Uploading application.yml'
        upload!("\#{Dir.pwd}/config/application.yml", "\#{fetch(:release_path)}/config")
      end
    end

    before :starting, 'maintenance:on'
    before :starting, 'monit:stop'
    before :compile_assets, :upload_app_yml
    before :published, 'nginx:create_nginx_config'
    before :published, 'unicorn:create_unicorn_config'
    before :published,'unicorn:create_unicorn_init'
    after :restart, 'monit:create_monit_conf'
    after :finished, 'monit:start'
    after :finished, 'maintenance:off'
  end
  CODE
            end
        end

        desc 'setup_capistrano', 'Run all capistrano setup actions in order'
        def setup_capistrano
          add_capistrano_gems
          run 'bundle exec cap install'
          configure_capfile
          run 'mkdir -p config/deploy/templates/maintenance'
          copy_templates
          add_tasks
          configure_env_files
        end

      end
    end
  end
end
