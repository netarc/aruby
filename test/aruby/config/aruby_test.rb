require "test_helper"

class Config::ARubyTest < Test::Unit::TestCase
  setup do
    @env = aruby_env
    @config = @env.config.aruby
  end

  context "defining debug" do
    should "have debug enabled by default" do
      assert @config.debug_enabled
    end
  end
end
