Capistrano::Configuration.instance.load do
  namespace :crom do 
    desc "Start crom process"
    task :start, :roles => :app do
      run "cd #{current_path}; RAILS_ENV=#{rails_env} script/crom start"
    end

    desc "Stop crom process"
    task :stop, :roles => :app do
      run "cd #{current_path}; RAILS_ENV=#{rails_env} script/crom stop"
    end

    desc "Restart crom process"
    task :restart, :roles => :app do
      run "cd #{current_path}; RAILS_ENV=#{rails_env} script/crom restart"
    end
  end
end
