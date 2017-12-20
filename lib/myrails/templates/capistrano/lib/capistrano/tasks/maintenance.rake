namespace :maintenance do
  desc 'Turn maintenance mode ON'
  task :on do
    on roles(:app) do
      execute :mkdir, "#{shared_path}/public/maintenance" if test("[ ! -d #{shared_path}/public/maintenance ]")
      upload! "config/deploy/templates/maintenance/index.html", "#{shared_path}/public/maintenance/index.html"
      execute :touch, "#{shared_path}/.maintenance"
    end
  end
  desc 'Turn maintenance mode OFF'
  task :off do
    on roles(:app) do
      execute :rm, "#{shared_path}/.maintenance"
    end
  end
end
