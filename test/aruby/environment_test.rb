require "test_helper"

class EnvironmentTest < Test::Unit::TestCase
  setup do
    @klass = ARuby::Environment
  end

  context "initialization" do
    should "set the cwd if given" do
      cwd = "foobarbaz"
      env = @klass.new(:cwd => cwd)
      assert_equal Pathname.new(cwd), env.cwd
    end

    should "default to pwd if cwd is nil" do
      env = @klass.new
      assert_equal Pathname.new(Dir.pwd), env.cwd
    end
  end

end
