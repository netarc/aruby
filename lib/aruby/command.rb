module ARuby
  module Command
    autoload :Base, 'aruby/command/base'
    autoload :Helpers, 'aruby/command/helpers'

    def self.builtin!
    end
  end
end

require 'aruby/command/compile'
