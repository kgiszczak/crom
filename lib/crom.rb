require 'rufus/scheduler'

require File.dirname(__FILE__) + '/crom/worker'
require File.dirname(__FILE__) + '/crom/version'
require File.dirname(__FILE__) + '/crom/railtie'

module Crom
  def self.schedule(&block)
    @tasks = block
  end

  def self.tasks
    @tasks || Proc.new {}
  end
end
