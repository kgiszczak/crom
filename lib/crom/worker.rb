module Crom
  class Worker
    @@logger = nil unless defined? @@logger

    def self.logger=(logger)
      @@logger = logger
    end

    def initialize
      @scheduler = Rufus::Scheduler.start_new
      Crom.schedule.each do |blk|
        instance_eval(&blk)
      end

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
      [ :schedule_in, :schedule_at, :every, :cron ].each do |method|
        class_eval <<-ENDEVAL
          def #{method}(t, s = nil, opts = {}, &block)
            decorated_block = Proc.new do
              log "\#{Time.now.strftime('%F %T')} | Processing task: #{method} \#{t}"
              begin
                #{defined?(ActiveRecord) ? 'ActiveRecord::Base.connection_pool.with_connection(&block)' : 'block.call'}
              rescue => e
                Crom.handle_errors.call(e) if Crom.handle_errors

                log '=' * 80
                log e.message
                log e.backtrace.join('\n')
                log '=' * 80
              end
            end
            @scheduler.#{method}(t, s, opts, &decorated_block)
          end
        ENDEVAL
      end

      def log(msg)
        @@logger.info msg if @@logger
      end
  end # class Worker
end # module Crom
