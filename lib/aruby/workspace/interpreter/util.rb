module ARuby
  class Interpreter
    protected

    # Given a package string return the module portion of the package.
    #
    # @example
    #
    #   module("Flash::Display::Sprite") => "Flash::Display"
    #   module("::Sprite")               => ""
    #   module("Sprite")                 => ""
    #
    # @param package [String] Complete or partial package string.
    def package_module(package)
      names = package.split('::')
      names.shift if names.empty? || names.first.empty?
      names.pop
      names.join('::')
    end
    
    # Given a package string return the class_name portion of the package.
    #
    # @example
    #
    #   module("Flash::Display::Sprite") => "Sprite"
    #   module("::Sprite")               => "Sprite"
    #   module("Sprite")                 => "Sprite"
    #
    # @param package [String] Complete or partial package string.
    def package_class_name(package)
      package.to_s.gsub(/^.*::/, '')
    end
  end
end
