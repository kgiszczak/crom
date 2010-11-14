module Crom
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'crom/tasks.rb'
    end
  end # class Railtie
end # module Crom
