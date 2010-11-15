require 'rubygems'
require 'daemons'

module Crom
  class Command
    def initialize(args)
      @args = args
      @pid_dir = Rails.root + 'tmp/pids'
      @files_to_reopen = []

      ObjectSpace.each_object(File) do |file|
        @files_to_reopen << file unless file.closed?
      end
    end

    def daemonize
      Daemons.run_proc('crom', :dir => @pid_dir, :dir_mode => :normal, :ARGV => @args) do |*args|
        run
      end
    end

    private
      def run
        Dir.chdir(Rails.root)

        @files_to_reopen.each do |file|
          begin
            file.reopen file.path, "a+"
            file.sync = true
          rescue ::Exception
          end
        end

        Crom::Worker.logger = Logger.new(Rails.root + 'log/crom.log')
        Crom::Worker.new.start
      rescue => e
        Rails.logger.fatal e
        STDERR.puts e.message
        exit 1
      end
  end # class Command
end # module Crom
