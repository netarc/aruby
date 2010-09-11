require 'pathname'
require 'json'
require 'i18n'

module ARuby

  autoload :CLI,         'aruby/cli'
  autoload :Config,      'aruby/config'
  autoload :Errors,      'aruby/errors'
  autoload :Environment, 'aruby/environment'
  autoload :Util,        'aruby/util'

  # The source root is the path to the root directory of the ARuby gem.
  def self.source_root
    @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
  end
end

# Default I18n to load the en locale
I18n.load_path << File.expand_path("templates/locales/en.yml", ARuby.source_root)
