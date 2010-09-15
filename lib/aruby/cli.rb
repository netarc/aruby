require 'thor'

module ARuby
  # Entrypoint for the ARuby CLI. This class should never be
  # initialized directly (like a typical Thor class). Instead,
  # use {Environment#cli} to invoke the CLI.
  class CLI < Thor

  end
end

# Anyway to autoload these into the CLI?
require 'aruby/command/compile'
require 'aruby/command/box'
