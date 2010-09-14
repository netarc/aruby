module ARuby
  module Command
    class MyCounter < Thor::Group
      include Thor::Actions
      add_runtime_options!

      def self.get_from_super
        from_superclass(:get_from_super, 13)
      end

      source_root File.expand_path(File.dirname(__FILE__))
      source_paths << File.expand_path("broken", File.dirname(__FILE__))

      argument :first,     :type => :numeric
      argument :second,    :type => :numeric, :default => 2

      class_option :third,  :type => :numeric, :desc => "The third argument", :default => 3,
      :banner => "THREE", :aliases => "-t"
      class_option :fourth, :type => :numeric, :desc => "The fourth argument"

      desc <<-FOO
Description:
  This generator runs three tasks: one, two and three.
FOO

      def one
        first
      end

      def two
        second
      end

      def three
        options[:third]
      end

      def self.inherited(base)
        super
        base.source_paths.unshift(File.expand_path(File.join(File.dirname(__FILE__), "doc")))
      end
    end

    class Barn < Thor
      desc "open [ITEM]", "open the barn door"
      def open(item = nil)
        if item == "shotgun"
          puts "That's going to leave a mark."
        else
          puts "Open sesame!"
        end
      end

      desc "paint [COLOR]", "paint the barn"
      method_option :coats, :type => :numeric, :default => 2, :desc => 'how many coats of paint'
      def paint(color='red')
        puts "#{options[:coats]} coats of #{color} paint"
      end

    end

    class BoxCommand < GroupBase
      desc "barn", "commands to manage the barn"
      subcommand "barn", ARuby::Command::Barn

    end
  end
end
