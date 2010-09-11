require 'fileutils'

module ARubyTestHelpers
  module Environment
    # Creates a .aruby file with the given contents in the given
    # app directory.
    def arubyfile(*args)
      path = args.shift.join(".aruby") if Pathname === args.first
      path ||= tmp_path.join(".aruby")
      str  = args.shift || ""
      file_contents = <<-EOF
ARuby::Config.run do |config|
  config.aruby.debug_enabled = true
  #{str}
end
EOF

      File.open(path.to_s, "w") do |f|
        f.puts file_contents
      end

      path.parent
    end

    # Creates and _loads_ a ARuby environment at the given path
    def aruby_env(*args)
      path = args.shift if Pathname === args.first
      path ||= arubyfile
      ARuby::Environment.new(:cwd => path).load!
    end
  end
end
