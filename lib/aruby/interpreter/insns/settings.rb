module ARuby
  class Interpreter
    protected

    # Flags for :trace
    RUBY_EVENT_NONE     = 0x0000
    RUBY_EVENT_LINE     = 0x0001
    RUBY_EVENT_CLASS    = 0x0002
    RUBY_EVENT_END      = 0x0004
    RUBY_EVENT_CALL     = 0x0008
    RUBY_EVENT_RETURN   = 0x0010
    RUBY_EVENT_C_CALL   = 0x0020
    RUBY_EVENT_C_RETURN = 0x0040
    RUBY_EVENT_RAISE    = 0x0080
    RUBY_EVENT_ALL      = 0xffff
    RUBY_EVENT_VM       = 0x10000
    RUBY_EVENT_SWITCH   = 0x20000
    RUBY_EVENT_COVERAGE = 0x40000

    iseq_define_ins :trace, [:nf], [] do
    end

  end
end
