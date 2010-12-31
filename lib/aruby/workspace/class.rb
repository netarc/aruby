module ARuby
  class Workspace
    def create_or_extend_class(klass_package, super_klass_package)
      @env.logger.info "checking for klass: #{klass_package}"
      return ARuby::Workspace::Class.new()
    end
    
    class Class
      
    end
  end
end
