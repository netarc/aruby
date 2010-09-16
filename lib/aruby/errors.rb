module ARuby
  module Errors
    # Main superclass of any errors in ARuby. This provides some
    # convenience methods for setting the status code and error key.
    # The status code is used by the `aruby` executable as the
    # error code, and the error key is used as a default message from
    # I18n.
    class ARubyError < StandardError
      @@used_codes = []

      def self.status_code(code = nil)
        if code
          raise "Status code already in use: #{code}"  if @@used_codes.include?(code)
          @@used_codes << code
        end

        define_method(:status_code) { code }
      end

      def self.error_key(key=nil, namespace=nil)
        define_method(:error_key) { key }
        error_namespace(namespace) if namespace
      end

      def self.error_namespace(namespace)
        define_method(:error_namespace) { namespace }
      end

      def initialize(message=nil, *args)
        message = { :_key => message } if message && !message.is_a?(Hash)
        message = { :_key => error_key, :_namespace => error_namespace }.merge(message || {})
        message = translate_error(message)

        super
      end

      # The default error namespace which is used for the error key.
      # This can be overridden here or by calling the "error_namespace"
      # class method.
      def error_namespace; "aruby.errors"; end

      # The key for the error message. This should be set using the
      # {error_key} method but can be overridden here if needed.
      def error_key; nil; end

      protected

      def translate_error(opts)
        return nil if !opts[:_key]
        I18n.t("#{opts[:_namespace]}.#{opts[:_key]}", opts)
      end
    end

    class CLIMissingEnvironment < ARubyError
      status_code(1)
      error_key(:cli_missing_env)
    end

    class ConfigFileSyntaxError < ARubyError
      status_code(2)
      error_key(:config_file_syntax_error)
    end

    class ConfigValidationFailed < ARubyError
      status_code(3)
      error_key(:config_validation)
    end

    class PathNotFound < ARubyError
      status_code(20)
      error_key(:path_not_found)
    end

    class PathNotFile < ARubyError
      status_code(21)
      error_key(:path_not_file)
    end

  end
end
