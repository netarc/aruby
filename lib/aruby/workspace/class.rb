module ARuby
  class Workspace
    def create_or_extend_class(klass_package, super_klass_package)
      @env.logger.info "checking for klass: #{klass_package} < #{super_klass_package}"
      
      klass = find_class(klass_package)
      unless klass
        klass = ARuby::Workspace::Class.new(klass_package, super_klass_package)
        @classes << klass
      end
      
      klass
    end
    
    def find_class(klass_package)
      nil
    end
    
    class Class
      attr_reader :klass_package, :super_klass_package
      
      def initialize(klass_package, super_klass_package)
        @klass_package = klass_package
        @super_klass_package = super_klass_package
      end
    end
  end
end
