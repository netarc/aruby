require 'pathname'
require 'json'
require 'i18n'
require 'byte_buffer'
require 'structured_object'
require 'ap'

module ARuby
  autoload :CLI,         'aruby/cli'
  autoload :Config,      'aruby/config'
  autoload :Command,     'aruby/command'
  autoload :Errors,      'aruby/errors'
  autoload :Environment, 'aruby/environment'
  autoload :Interpreter, 'aruby/interpreter'
  autoload :SWF,         'aruby/swf'
  autoload :UI,          'aruby/ui'
  autoload :Util,        'aruby/util'
  autoload :VERSION,     'aruby/version'

  # The source root is the path to the root directory of the ARuby gem.
  def self.source_root
    @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
  end
  
  def self.print_obj(obj)
    ap(obj, :multiline => false)
  end
  
  def self.print_multiline(obj)
    awesome_print obj, :multiline => true, :indent => 2
  end
end

# Default I18n to load the en locale
I18n.load_path << File.expand_path("templates/locales/en.yml", ARuby.source_root)

require 'aruby/exts'
