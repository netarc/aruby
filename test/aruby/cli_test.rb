require "test_helper"

class CLITest < Test::Unit::TestCase
  setup do
    @klass = ARuby::CLI
  end

  context "registering" do
    should "register a base command as a single invokable" do
      base = Class.new(ARuby::Command::Base)
      name = "__test_registering_single_subcommand"
      @klass.register(base, name, name, "A description")
      assert @klass.tasks[name]
    end
  end
end
