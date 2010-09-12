module ARuby
  module Command
    autoload :Base, 'aruby/command/base'

    def self.builtin!
    end
  end
end

require 'aruby/command/compile'
