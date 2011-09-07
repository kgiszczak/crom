require 'rufus/scheduler'

require File.dirname(__FILE__) + '/crom/worker'
require File.dirname(__FILE__) + '/crom/version'
require File.dirname(__FILE__) + '/crom/railtie' if defined?(Rails)

module Crom
  def self.schedule(&block)
    @tasks = block if block
    @tasks || Proc.new {}
  end

  def self.handle_errors(&block)
    @error_handler = block if block
    @error_handler
  end
end
