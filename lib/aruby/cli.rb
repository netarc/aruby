require 'thor'

module ARuby
  # Entrypoint for the ARuby CLI. This class should never be
  # initialized directly (like a typical Thor class). Instead,
  # use {Environment#cli} to invoke the CLI.
  class CLI < Thor

  end
end

# TODO: A Cleaner way?
require 'aruby/command/compile'
require 'aruby/command/version'
#require 'aruby/command/box'
