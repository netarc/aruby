module ARuby
  module Command
    class BoxCommand < GroupBase

      subcommand "barn", "holds the animals", BoxCommand

      class_option :third,  :type => :numeric, :desc => "The third argument", :default => 3, :banner => "THREE", :aliases => "-t"
      class_option :fourth, :type => :numeric, :desc => "The fourth argument"

      desc "add NAME URI", "Add a box to the system"
      def add(name, uri)
      end

      desc "remove NAME", "Remove a box from the system"
      def remove(name)
      end

    end
  end
end
