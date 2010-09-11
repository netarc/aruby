# Add this folder to the load path for "test_helper"
$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'aruby'
require 'contest'
require 'mocha'
require 'support/path'
require 'support/environment'

# Try to load ruby debug since its useful if it is available.
begin
  require 'ruby-debug'
rescue LoadError
end

class Test::Unit::TestCase
  include ARubyTestHelpers::Path
  include ARubyTestHelpers::Environment

end
