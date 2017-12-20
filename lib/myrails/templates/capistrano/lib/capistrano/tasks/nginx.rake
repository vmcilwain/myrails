# Capistrano file for setting up nginx during application deployment
set :nginx_template, 'config/deploy/templates/nginx.conf.erb'
set :nginx_conf, "tmp/nginx.conf"

namespace :nginx do
  desc 'restart nginx'
  task :restart do
    on roles(:app) do
      info 'Restarting nginx'
      # execute :sudo, "fuser -k 80/tcp"
      execute :sudo, 'service nginx stop'
      execute :sudo, "service nginx start"
    end
  end

  desc "create #{fetch(:application)} nginx.conf"
  task :generate_nginx_conf do
    on roles(:app) do
      info "Generating #{fetch(:application)} nginx.conf file"
      open(fetch(:nginx_conf), 'w') do |f|
        f.puts(ERB.new(File.read(fetch(:nginx_template))).result(binding))
      end
    end
  end

  desc "upload #{fetch(:application)} nginx.conf"
  task :upload do
    on roles(:app) do
      upload!(fetch(:nginx_conf), "#{current_path}/config")
    end
  end

  desc "delete local #{fetch(:application)} nginx.conf"
  task :remove do
    on roles(:app) do
      info 'Removing local nginx.conf'
      FileUtils.rm(fetch(:nginx_conf))
    end
  end

  desc "create symlink for #{fetch(:application)} nginx.conf"
  task :create_symlink do
    on roles(:app) do
      info 'Creating symlink on remote system'
      execute :sudo, "ln -s #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
    end
  end

  desc "remove symlink for #{fetch(:application)} nginx.conf"
  task :remove_symlink do
    on roles(:app) do
      info 'Removing symlink on remote system'
      execute :sudo, "rm -rf /etc/nginx/sites-enabled/#{fetch(:application)}"
    end
  end

  desc "add nginx config to #{fetch(:application)}"
  task :create_nginx_config do
    on roles(:app) do |host|
      info "Creating #{fetch(:application)} nginx.conf"
      invoke 'nginx:generate_nginx_conf'
      invoke 'nginx:upload'
      invoke 'nginx:remove'
      invoke 'nginx:remove_symlink'
      invoke 'nginx:create_symlink'
    end
  end
end
