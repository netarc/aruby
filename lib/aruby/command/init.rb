module ARuby
  module Command
    class InitCommand < Base

      desc "init NAME", "create a default .aruby project file with the specified name"

      argument :output, :type => :string
      map "-i" => :init

      def execute
        dest_path = File.expand_path(File.join(output, '.aruby'), env.cwd)

        if File.exists?(source_path)
          puts "file exists, overwrite?"
          if !env.ui.yes? "vagrant.commands.upgrade_to_060.ask", :_prefix => false, :_color => :yellow
            puts "oh noes"
          end
        end

      end
    end
  end
end
