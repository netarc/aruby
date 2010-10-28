module ARuby
  module Command
    class InitCommand < Base

      desc "init FILE", "create a default .aruby project file with the specified name"
      source_root File.expand_path("templates/commands/init", ARuby.source_root)

      argument :file, :type => :string
      map "-i" => :init

      def execute
        dest_path = File.expand_path(File.join("#{file}.aruby"), env.cwd)

        if File.exists?(dest_path)
          if !env.ui.yes? "aruby.commands.init.overwrite_ask", :_color => :yellow
            env.ui.info "aruby.commands.general.abort"
            return
          end
        end

        template "project_file.erb", dest_path
      end
    end
  end
end
