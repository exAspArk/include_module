module IncludeModuleTest
  module TestModule
    module ClassMethods
      def bar; :bar_class; end
      def foo; :foo_class; end
      def foo_bar; :foo_bar_class; end
      def included_ran=(value); @included_ran = value; end
      def included_ran; @included_ran; end
    end

    INCLUDED = proc { self.included_ran = true }

    def foo; :foo_instance; end
    def bar; :bar_instance; end
    def foo_bar; :foo_bar_instance; end
  end

  module NestedTestModule
    extend IncludeModule
    include_module TestModule, methods: :all, included: false

    module ClassMethods
      extend IncludeModule
      include_module TestModule::ClassMethods, methods: :all

      def foo; "foo + #{super}"; end
      def included_ran2=(value); @included_ran2 = value; end
      def included_ran2; @included_ran2; end
    end

    INCLUDED = proc { self.included_ran2 = 'included' }

    def bar; "bar + #{super}"; end
    def bar2; "#{bar} + bar2"; end
  end

  module TestModule1
    module ClassMethods
      def bar; @bar; end
    end

    INCLUDED = proc { @bar = :bar1 }

    def foo; :foo1; end
  end

  module NestedModule2
    extend IncludeModule
    include_module TestModule1, methods: :all, included: true

    module ClassMethods
      extend IncludeModule
      include_module TestModule1::ClassMethods, methods: :all

      def bar; "#{super} + bar22"; end
    end

    INCLUDED = proc { @bar = "#{@bar} + bar21" }

    def foo; "#{super} + foo2"; end
  end

  module NestedModule3
    extend IncludeModule
    include_module NestedModule2, methods: :all, included: true

    module ClassMethods
      extend IncludeModule
      include_module NestedModule2::ClassMethods, methods: :all

      def bar; "#{super} + bar32"; end
    end

    INCLUDED = proc { @bar = "#{@bar} + bar31" }

    def foo; "#{super} + foo3"; end
  end

  module TestClassicModule
    module ClassMethods
      def bar; :bar_class; end
      def foo; :foo_class; end
      def included_ran=(value); @included_ran = value; end
      def included_ran; @included_ran; end
    end

    def self.included(base)
      base.extend ClassMethods
      base.class_eval { self.included_ran = true }
    end

    def foo; :foo_instance; end
    def bar; :bar_instance; end
  end
end

