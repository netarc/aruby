require 'pathname'

module ARuby

  autoload :Config, 'aruby/config'

  # The source root is the path to the root directory of the ARuby gem.
  def self.source_root
    @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
  end
end
