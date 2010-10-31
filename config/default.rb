ARuby::Config.run do |config|
  config.aruby.log_output = STDOUT
  config.aruby.debug_enabled = true

  config.swf.entry_class = "Main"
  config.swf.entry_file = "file"
end
