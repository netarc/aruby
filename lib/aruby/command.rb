module ARuby
  module Command
    autoload :Base, 'aruby/command/base'
    autoload :GroupBase, 'aruby/command/group_base'
    autoload :Helpers, 'aruby/command/helpers'

    def self.builtin!
    end
  end
end

require 'aruby/command/compile'
require 'aruby/command/version'
