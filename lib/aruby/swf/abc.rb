module ARuby
  class SWF
    class ABC
      FLASH_API_HIERARCHY = {
        "Object" => {
          "flash.events:EventDispatcher" => {
            "flash.display:DisplayObject" => {
              "flash.display:InteractiveObject" => {
                "flash.display:DisplayObjectContainer" => {
                  "flash.display:Sprite" => nil
                }
              }
            }
          }
        }
      }

      attr_accessor :entry_class

      attr_accessor :constant_pool
      attr_accessor :abc_methods
      attr_accessor :metadatas
      attr_accessor :instances, :classes
      attr_accessor :scripts
      attr_accessor :method_bodies
      attr_accessor :hierarchy

      def initialize
        reset
        setup_flash_hierarchy
      end

      def reset
        @entry_class = ""

        @constant_pool = ARuby::SWF::ABC::ConstantPool.new
        @abc_methods = []
        @metadatas = []
        @instances = []
        @classes = []
        @scripts = []
        @method_bodies = []

        @minor_version = 16
        @major_version = 46
      end

      def hierarch_process(hash, parent=nil)
        hash.each_key do |k,v|
          @hierarchy[k] = parent
          hierarch_process(hash[k], k) unless hash[k].nil?
        end
      end

      def setup_flash_hierarchy()
        @hierarchy = {}

        hierarch_process(FLASH_API_HIERARCHY)
      end

      def serialize(io=nil)
        io ||= ByteBuffer.new

        puts "\n\n\n- ABC Serialize".whiteish

        ARuby.print_multiline @hierarchy

        io.write_ui16 @minor_version
        io.write_ui16 @major_version

        @constant_pool.write_to_io(io)

        io.write_u30 @abc_methods.length
        puts "+ Write Methods(#{@abc_methods.length}):".yellowish
        @abc_methods.each do |v|
          v.serialize(io)
        end
        ARuby.print_multiline @abc_methods

        io.write_u30 @metadatas.length
        puts "+ Write Metadata(#{@metadatas.length}):".yellowish
        @metadatas.each { |v| v.write_to_io(io) }
        ARuby.print_multiline @metadatas

        io.write_u30 @classes.length
        puts "+ Write Instances(#{@classes.length}):".yellowish
        @instances.each { |v| v.write_to_io(io) }
        ARuby.print_multiline @instances
        puts "+ Write Classes(#{@classes.length}):".yellowish
        @classes.each { |v| v.serialize(io) }
        ARuby.print_multiline @classes

        io.write_u30 @scripts.length
        puts "+ Write Scripts(#{@scripts.length}):".yellowish
        @scripts.each { |v| v.write_to_io(io) }
        ARuby.print_multiline @scripts

        io.write_u30 @method_bodies.length
        puts "+ Write Method Bodies(#{@method_bodies.length}):".yellowish
        @method_bodies.each { |v| v.write_to_io(io) }
        ARuby.print_multiline @method_bodies

        io
      end

      def unserialize(io)
        puts "- ABC Unserialize".whiteish

        ARuby.print_multiline @hierarchy

        @minor_version = io.read_ui16
        @major_version = io.read_ui16

        @constant_pool.read_from_io(io)

        size = io.read_u30
        puts "+ Read Methods(#{size}):".yellowish
        1.upto(size) do |i|
          @abc_methods << ARuby::SWF::ABC::Method.new_from_io(io, self)
        end
        ARuby.print_multiline @abc_methods

        size = io.read_u30
        puts "+ Read Metadata(#{size}):".yellowish
        1.upto(size) do |i|
          @metadatas << ARuby::SWF::ABC::MetaData.new(self).read_from_io(io)
        end
        ARuby.print_multiline @metadatas

        size = io.read_u30
        puts "+ Read Instances(#{size}):".yellowish
        1.upto(size) do |i|
          @instances << ARuby::SWF::ABC::Instance.new(self).read_from_io(io)
        end
        ARuby.print_multiline @instances
        puts "+ Read Classes(#{size}):".yellowish
        1.upto(size) do |i|
          @classes << ARuby::SWF::ABC::Class.new_from_io(io, self)
        end
        ARuby.print_multiline @classes

        size = io.read_u30
        puts "+ Read Scripts(#{size}):".yellowish
        1.upto(size) do |i|
          @scripts << ARuby::SWF::ABC::Script.new(self).read_from_io(io)
        end
        ARuby.print_multiline @scripts

        size = io.read_u30
        puts "+ Read Method Bodies(#{size})".yellowish
        1.upto(size) do |i|
          @method_bodies << ARuby::SWF::ABC::MethodBody.new(self).read_from_io(io)
        end
        ARuby.print_multiline @method_bodies
      end

    #===============================================================================
    # Accessors
    #===============================================================================

      def get_hierarchy(m)
        hierarchy = []
        cur = get_parent(m)
        last = nil
        while cur != nil && last != nil
          last = cur
          hierarchy.unshift(cur)
          cur = @hierarchy[cur]
        end
        hierarchy
      end

      def get_parent(m)
        @hierarchy[(m.ns.name.to_s+":"+m.name.to_s).to_s]
      end

      %w(ints uints doubles strings namespaces multinames ns_sets).each do |forward|
        define_method(forward) { @constant_pool.send(forward) }
      end

    #===============================================================================
    #
    #===============================================================================

      def create_class(klass)
        unless klass.is_a?(ARuby::Workspace::Class)
          raise StandardError, "invalid klass object"
        end

        class_index, cls, inst, is_new = create_or_find_class(klass.klass_package, klass.super_klass_package)

        unless is_new
          raise StandardError, "Class already exists: #{klass.class_name}"
        end

        create_class_init_method(cls)
        create_doc_class_init_script(inst, class_index, 1)

        has_constructor = false

  #       klass.methods[:instance][:private].each do |kmethod|
  #         puts "Found private method: #{kmethod.name}"
  #         # method = @abc_methods[m_index]
  #         # name = method.name.to_s
  #         # name.match(/^(?:\w+\/)?(\w+)$/)
  #         # mn = get_qname($1, "", ARuby::SWF::ABC::Namespace::PackageNamespace)
  #         #
  #         # trait = ARuby::SWF::ABC::Trait.new(self)
  #         # trait.name_index = mn
  #         # trait.type = ARuby::SWF::ABC::Trait::MethodId
  #         # trait.data = ARuby::SWF::ABC::TraitMethod.new(self)
  #         # trait.data.disp_id = 0
  #         # trait.data.method_index = m_index
  #         # inst.traits << trait
  #       end
  #       klass.methods[:instance][:protected].each do |kmethod|
  #         puts "Found protected method: #{kmethod.name}"
  #         # method = @abc_methods[m_index]
  #         # name = method.name.to_s
  #         # name.match(/^(?:\w+\/)?(\w+)$/)
  #         # mn = get_qname($1, "", ARuby::SWF::ABC::Namespace::PackageNamespace)
  #         #
  #         # trait = ARuby::SWF::ABC::Trait.new(self)
  #         # trait.name_index = mn
  #         # trait.type = ARuby::SWF::ABC::Trait::MethodId
  #         # trait.data = ARuby::SWF::ABC::TraitMethod.new(self)
  #         # trait.data.disp_id = 0
  #         # trait.data.method_index = m_index
  #         # inst.traits << trait
  #       end
  #       klass.methods[:instance][:public].each do |kmethod_key, kmethod|
  #         puts "Found public method: #{kmethod.name}"
  #         if kmethod_key == :"initialize"
  #           method_inst, method_inst_body = create_class_method_stub
  #           method_inst_body.code.codes.insert(-1, *kmethod.codes)
  #           method_inst_body.code.codes << ARuby::SWF::ABC::OpCode::ReturnVoid.new(self)
  #           has_constructor = true
  #           inst.iinit_index = method_inst_body.method_index
  #         else
  #           method_inst, method_inst_body = create_class_method_stub
  #           method_inst_body.code.codes.insert(-1, *kmethod.codes)
  # #          method_inst_body.code.codes << ARuby::SWF::ABC::OpCode::ReturnVoid.new(self)
  #           method_inst_body.code.codes << ARuby::SWF::ABC::OpCode::ReturnValue.new(self)
  #         end
  # 
  #         method_inst_body.code.codes.insert(0, *[ARuby::SWF::ABC::OpCode::DebugFile.new(self, :index => @constant_pool.add_string("/Users/jhollenbeck/Projects/aruby/test;;Basic.as")), ARuby::SWF::ABC::OpCode::DebugLine.new(self, :value => method_inst_body.method_index)])
  #         method_inst_body.max_stack = kmethod.max_stack_depth
  #         method_inst_body.local_count = kmethod.local_count
  #         method_inst_body.init_scope_depth = 9
  #         method_inst_body.max_scope_depth = 10
  # 
  #         # redefine_abc method_inst_body.code.codes
  # 
  #         if kmethod_key != :"initialize"
  #           name = kmethod_key
  #           name.match(/^(?:\w+\/)?(\w+)$/)
  #           mn = get_qname($1, "", ARuby::SWF::ABC::Namespace::PackageNamespace)
  # 
  #           trait = ARuby::SWF::ABC::Trait.new(self)
  #           trait.name_index = mn
  #           trait.type = ARuby::SWF::ABC::Trait::MethodId
  #           trait.data = ARuby::SWF::ABC::TraitMethod.new(self)
  #           trait.data.disp_id = 0
  #           trait.data.method_index = method_inst_body.method_index
  #           inst.traits << trait
  #         end
  #       end


        # klass.methods[:singleton][:public].each do |kmethod_key, kmethod|
        #   puts "Found public class method: #{kmethod.name}"
        # 
        #   method_inst, method_inst_body = create_class_method_stub
        #   method_inst_body.code.codes.insert(-1, *kmethod.codes)
        #   method_inst_body.code.codes << ARuby::SWF::ABC::OpCode::ReturnValue.new(self)
        # 
        #   method_inst_body.code.codes.insert(0, *[ARuby::SWF::ABC::OpCode::DebugFile.new(self, :index => @constant_pool.add_string("/Users/jhollenbeck/Projects/aruby/test;;Basic.as")), ARuby::SWF::ABC::OpCode::DebugLine.new(self, :value => method_inst_body.method_index)])
        #   method_inst_body.max_stack = kmethod.max_stack_depth
        #   method_inst_body.local_count = kmethod.local_count
        #   method_inst_body.init_scope_depth = 9
        #   method_inst_body.max_scope_depth = 10
        # 
        # 
        #   name = kmethod_key
        #   name.match(/^(?:\w+\/)?(\w+)$/)
        #   mn = get_qname($1, "", ARuby::SWF::ABC::Namespace::PackageNamespace)
        # 
        #   trait = ARuby::SWF::ABC::Trait.new(self)
        #   trait.name_index = mn
        #   trait.type = ARuby::SWF::ABC::Trait::MethodId
        #   trait.data = ARuby::SWF::ABC::TraitMethod.new(self)
        #   trait.data.disp_id = 0
        #   trait.data.method_index = method_inst_body.method_index
        #   cls.traits << trait
        # end

        unless has_constructor
          inst.iinit_index = create_class_constructor_stub
        end


      end


    private

      # Given a full class name and its super, find or create a class/instance for it
      def create_or_find_class(fullname, super_fullname="")
        # Determine Class/Super Names
        class_name, class_package_name = split_name_package(fullname)
        super_class_name, super_class_package_name = split_name_package(super_fullname)
        # Namespaces
        class_ns = get_qname(class_name, class_package_name, ARuby::SWF::ABC::Namespace::PackageNamespace)
        super_class_ns = get_qname(super_class_name, super_class_package_name, ARuby::SWF::ABC::Namespace::PackageNamespace)
        # Does class already exist?
        inst_idx = find_instance_by_name_index(class_ns)
        return [inst_idx, classes[inst_idx], instances[inst_idx], false] unless inst_idx.nil?

        class_index = instances.length

        cls = ARuby::SWF::ABC::Class.new(self)
        classes << cls

        inst = ARuby::SWF::ABC::Instance.new(self)
        instances << inst

        inst.name_index = class_ns
        inst.super_name_index = super_class_ns
        inst.flags = ARuby::SWF::ABC::Instance::ProtectedNamespace
        inst.protected_namespace_index = find_or_create_namespace(protected_namespace_name(class_name, class_package_name), ARuby::SWF::ABC::Namespace::ProtectedNamespace)

        register_instance_hierarchy(inst)

        [class_index, cls, inst, true]
      end

      def find_instance_by_name_index(idx)
        1.upto(instances.size) do |idx|
          return idx if instances[idx].name_index == class_ns
        end
        nil
      end



      # Create an empty Method and Method Body
      def create_method
        # Create Method
        method = ARuby::SWF::ABC::Method.new(self)
        method_index = @abc_methods.length
        @abc_methods << method
        # Create Method Body
        method_body = ARuby::SWF::ABC::MethodBody.new(self)
        method_body_index = @method_bodies.length
        @method_bodies << method_body
        # Cross Link
        method.body_index = method_body_index
        method_body.method_index = method_index

        [method, method_body]
      end

      # Create a method to initialize a class
      def create_class_init_method(cls)
        method_inst, method_inst_body = create_method

        cls.cinit_index = method_inst.body_index

        method_inst.return_type_index = 0
        method_inst.name_index = @constant_pool.add_string("")

        method_inst_body.max_stack = 1
        method_inst_body.local_count = 1
        method_inst_body.init_scope_depth = 8
        method_inst_body.max_scope_depth = 9
        codes = method_inst_body.code.codes
        codes << ARuby::SWF::ABC::OpCode::GetLocal0.new(self)
        codes << ARuby::SWF::ABC::OpCode::PushScope.new(self)
        codes << ARuby::SWF::ABC::OpCode::ReturnVoid.new(self)
      end

      # Create a stub for a class constructor
      def create_class_constructor_stub
        # Create our new Method
        method_inst, method_inst_body = create_method
        # Method can return anything
        method_inst.return_type_index = 0

        method_inst.param_types = Array.new(0, 0)
        method_inst_body.init_scope_depth = 9
        method_inst_body.max_scope_depth = 10

        codes = method_inst_body.code.codes
        codes << ARuby::SWF::ABC::OpCode::GetLocal0.new(self)
        codes << ARuby::SWF::ABC::OpCode::PushScope.new(self)
        codes << ARuby::SWF::ABC::OpCode::GetLocal0.new(self)
        codes << ARuby::SWF::ABC::OpCode::ConstructSuper.new(self, :arg_count => 0)
        codes << ARuby::SWF::ABC::OpCode::ReturnVoid.new(self)
        method_inst_body.max_stack = 1
        method_inst_body.local_count = 1

        method_inst_body.method_index
      end

      # Create a stub for a class constructor
      def create_class_method_stub
        # Create our new Method
        method_inst, method_inst_body = create_method
        # Method can return anything
        method_inst.return_type_index = 0

        method_inst.param_types = Array.new(0, 0)
        method_inst_body.init_scope_depth = 0
        method_inst_body.max_scope_depth = 1

        codes = method_inst_body.code.codes
        codes << ARuby::SWF::ABC::OpCode::GetLocal0.new(self)
        codes << ARuby::SWF::ABC::OpCode::PushScope.new(self)
        method_inst_body.max_stack = 1
        method_inst_body.local_count = 1

        [method_inst, method_inst_body]
      end








       def create_class_init_method_body(inst, class_index, mbody)

          mbody.max_stack = 2
          mbody.local_count = 1
          mbody.init_scope_depth = 1
          # number of parent classes
          mbody.max_scope_depth = 8

          codes = mbody.code.codes

          codes << ARuby::SWF::ABC::OpCode::GetLocal0.new(self)
          codes << ARuby::SWF::ABC::OpCode::PushScope.new(self)

          # Insert any OpCode if needed
          yield codes if block_given?


          hierarchy = get_hierarchy(inst.name)
          hierarchy.each do |clz_sym|
            match = clz_sym.to_s.match(/^(?:([\w.]+):)?(\w+)$/)
            package, name = match[1] || "", match[2]
            ns = get_qname(name, package, ARuby::SWF::ABC::Namespace::PackageNamespace)
            codes << ARuby::SWF::ABC::OpCode::GetLex.new(self, :index => ns)
            codes << ARuby::SWF::ABC::OpCode::PushScope.new(self)
          end

          clz_sym = hierarchy.last
          match = clz_sym.to_s.match(/^(?:([\w.]+):)?(\w+)$/)
          package, name = match[1] || "", match[2]
          ns = get_qname(name, package, ARuby::SWF::ABC::Namespace::PackageNamespace)
          codes << ARuby::SWF::ABC::OpCode::GetLex.new(self, :index => ns)

          codes << ARuby::SWF::ABC::OpCode::NewClass.new(self, :index => class_index)

          hierarchy.each do |clz|
            codes << ARuby::SWF::ABC::OpCode::PopScope.new(self)
          end

          codes << ARuby::SWF::ABC::OpCode::InitProperty.new(self, :index => inst.name_index)
          codes << ARuby::SWF::ABC::OpCode::ReturnVoid.new(self)
        end


        def create_doc_class_init_script(inst, class_index, declared_on_line)
          script_index = shared_class_script_init(inst, class_index)
          scr = scripts[script_index]

          create_class_init_method_body(inst, class_index, scr.init.body) do |codes|
            codes << ARuby::SWF::ABC::OpCode::DebugFile.new(self, :index => @constant_pool.add_string("/Users/jhollenbeck/Projects/aruby;;example.rb"))
            codes << ARuby::SWF::ABC::OpCode::DebugLine.new(self, :linenum => declared_on_line)

            codes << ARuby::SWF::ABC::OpCode::GetScopeObject.new(self, :index => 0)
          end
        end

        def create_class_init_script(inst, class_index, declared_on_line)
          script_index = shared_class_script_init(inst, class_index)
          scr = scripts[script_index]

          create_class_init_method_body(inst, class_index, scr.init.body) do |codes|
            op = ARuby::SWF::ABC::OpCode::FindPropStrict.new(self)
            # set multiname ns_set and classname
            codes << op
          end
        end
        def shared_class_script_init(inst, class_index)
          scr = ARuby::SWF::ABC::Script.new(self)
          script_index = scripts.length
          scripts << scr

          method, method_body = create_method()

          method.return_type_index = 0
          method.name_index = @constant_pool.add_string("")

          scr.init_index = method_body.method_index

          trait = ARuby::SWF::ABC::Trait.new(self)
          scr.traits << trait

          trait.name_index = inst.name_index
          trait.type = ARuby::SWF::ABC::Trait::ClassId
          trait.data = ARuby::SWF::ABC::TraitClass.new(self)
          trait.data.slot_id = 1
          trait.data.class_index = class_index

          script_index
        end


      def register_instance_hierarchy(inst)
        clz_sym = (inst.name.ns.name.to_s+":"+inst.name.name.to_s).to_s
        par_sym = (inst.super_name.ns.name.to_s+":"+inst.super_name.name.to_s).to_s
        puts " * register_instance_hierarchy: #{clz_sym.inspect} => #{par_sym.inspect}"
        @hierarchy[clz_sym] = par_sym
      end

      # flash.dislay.Sprite => ["Sprite", "flash.display"]
      # Flash.Dislay.Sprite => ["Sprite", "flash.display"]
      def split_name_package(fullname)
        # puts "fullname: #{fullname}"
        # parts = fullname.split(':')
        # puts "parts: #{parts.inspect}"
        # if parts.length > 1
        #   name = parts[1]
        #   package = parts[0]
        # else
        #   name = parts[0]
        #   package = ""
        # end
        
        split = fullname.to_s.gsub(/:/, ".").match(/^(?:((?:\w+\.?)*)\.)?(\w+)$/) || []
        puts "split: #{split.inspect}"
        name = split[2] || ""
        package = split[1] || ""
        # downcase the first letter of each package name
        package = package.split(".").map {|s| s[0].downcase+s[1..-1]}.join(".")
        [name, package]
      end

      def protected_namespace_name(name, package)
        if package and package != ""
          package + ":" + name
        else
          name
        end
      end

      def find_or_create_namespace(name, type)
        # name = name.to_sym if not name.is_a? Symbol
        name_index = @constant_pool.add_string(name)
        @constant_pool.add_namespace(ARuby::SWF::ABC::Namespace.new(type, name_index, @constant_pool))
      end

      def get_qname(name, namespace, ns_kind=nil)
        puts "getting qname for - #{namespace}::#{name}"
        # name = name.to_sym if not name.is_a? Symbol
        if (namespace.is_a? Integer)
          ns_index = namespace
        else
          ns_index = find_or_create_namespace(namespace, ns_kind)
        end
        name_index = @constant_pool.add_string(name)
        mn_index = @constant_pool.add_multiname(ARuby::SWF::ABC::Multiname.new(ARuby::SWF::ABC::Multiname::MultinameQName, name_index, ns_index, nil, @constant_pool))
      end
    end
  end
end

require 'aruby/swf/abc/instance'
require 'aruby/swf/abc/trait'
require 'aruby/swf/abc/script'
require 'aruby/swf/abc/code'
require 'aruby/swf/abc/opcode'
require 'aruby/swf/abc/method'
require 'aruby/swf/abc/method_body'
require 'aruby/swf/abc/exception'
require 'aruby/swf/abc/class'
require 'aruby/swf/abc/constant_pool'
require 'aruby/swf/abc/namespace'
require 'aruby/swf/abc/multiname'
require 'aruby/swf/abc/metadata'
require 'aruby/swf/abc/metadata_item'
require 'aruby/swf/abc/ns_set'