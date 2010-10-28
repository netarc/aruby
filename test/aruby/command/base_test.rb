require "test_helper"

class CommandBaseTest < Test::Unit::TestCase
  setup do
    @klass = ARuby::Command::Base
    @env = aruby_env
  end

  context "initialization" do
    should "require an environment" do
      assert_raises(ARuby::Errors::CLIMissingEnvironment) { @klass.new([], {}, {}) }
      assert_nothing_raised { @klass.new([], {}, { :env => @env }) }
    end
  end
end
