# Add this folder to the load path for "test_helper"
$:.unshift(File.dirname(__FILE__))

require 'aruby'
require 'contest'

# Try to load ruby debug since its useful if it is available.
begin
  require 'ruby-debug'
rescue LoadError
end

class Test::Unit::TestCase

end
