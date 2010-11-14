require 'active_support/core_ext/class/attribute_accessors'

module Crom
  class Worker
    cattr_accessor :logger

    def initialize
      @scheduler = Rufus::Scheduler.start_new
      instance_eval(&Crom.tasks)

      trap("TERM") { stop }
      trap("INT")  { stop }
    end

    def start
      log "Crom Worker started at #{Time.now.strftime('%F %T')}"
      @scheduler.join
    end

    def stop
      log "Crom Worker stopped at #{Time.now.strftime('%F %T')}"
      @scheduler.stop
    end

    private
      [ :schedule_in, :at, :every, :cron ].each do |method|
        class_eval <<-ENDEVAL
          def #{method}(t, s = nil, opts = {}, &block)
            decorated_block = Proc.new do
              log "\#{Time.now.strftime('%F %T')} | Processing task: #{method} \#{t}"
              begin
                block.call
              rescue
                log $!
              end
            end
            @scheduler.#{method}(t, s, opts, &decorated_block)
          end
        ENDEVAL
      end

      def log(msg)
        logger.info msg if logger
      end
  end # class Worker
end # module Crom
