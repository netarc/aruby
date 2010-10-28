require "test_helper"

class CommandCompileTest < Test::Unit::TestCase
  setup do
    @klass = ARuby::Command::CompileCommand
    @env = aruby_env
  end

  should "compile a specified file" do
    assert_nothing_raised do
      @klass.start(['../fixtures/hello_world.rb'], :env => @env)
    end
  end
end
