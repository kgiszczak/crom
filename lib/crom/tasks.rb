namespace :crom do
  desc "Start a crom worker."
  task :start => :environment do
    load Rails.root + 'config/schedule.rb'
    Crom::Worker.new.start
  end
end
