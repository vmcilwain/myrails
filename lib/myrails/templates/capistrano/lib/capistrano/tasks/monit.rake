# Monit file for setting up monit during application deployment
set :template, "config/deploy/templates/monit.conf.erb"
set :monit_conf, "tmp/monit.conf"

namespace :monit do

  desc 'creation of monit file for application'
  task :write_monit_conf do
    on roles(:app) do
      info "Creating monit config"
      open(fetch(:monit_conf), 'a') do |f|
        f.puts(ERB.new(File.read("#{fetch(:template)}"), nil, '-').result(binding))
      end
    end
  end

  desc 'restart monit application'
  task :reload do
    on roles(:app) do
      info 'Reloading initialize monit'
      execute :sudo, 'service monit reload' # re-read /etc/monit/monitrc
    end
  end

  desc 'stop monit application'
  task :stop do
    on roles(:app) do
      info 'Stopping initialize monit'
      execute :sudo, 'service monit stop'
    end
  end

  desc 'start monit application'
  task :start do
    on roles(:app) do
      info 'Starting initialize monit'
      execute :sudo, 'service monit start'
    end
  end

  desc 'upload monit config to app'
  task :upload do
    on roles(:app) do
      upload!(fetch(:monit_conf), "#{current_path}/config")
    end
  end

  desc 'remove temp file'
  task :remove do
    on roles(:app) do
      FileUtils.rm(fetch(:monit_conf))
    end
  end

  desc 'start creation of monit file for application'
  task :create_monit_conf do
    on roles(:app) do
      info "Creating #{fetch(:application)} config/monit.config"
      invoke 'monit:write_monit_conf'
      invoke 'monit:upload'
      invoke 'monit:remove'
    end
  end
end
