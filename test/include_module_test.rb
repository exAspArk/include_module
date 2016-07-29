require "minitest/autorun"
require "pry-byebug"

require_relative '../lib/include_module'

require_relative './test_modules'

module IncludeModuleTest
  class Including < Minitest::Test
    class WithTestModule
      extend IncludeModule

      include_module TestModule,
        instance_methods: [:foo, bar: :baz],
        class_methods: [:bar, :included_ran, :included_ran=, foo: :foz],
        included: true
    end

    def test_including_instance_methods
      instance = WithTestModule.new

      assert_equal instance.foo, :foo_instance
      assert_equal instance.baz, :bar_instance
      assert_raises(NoMethodError) { instance.bar }
      assert_raises(NoMethodError) { instance.foo_bar }
    end

    def test_adding_anonymous_module_in_acestors
      included_module = WithTestModule.included_modules.first

      assert_equal included_module.name, nil
      assert WithTestModule.included_modules.include?(included_module)
      assert WithTestModule.ancestors.include?(included_module)

      methods = included_module.instance_methods
      assert methods.include?(:foo)
      assert methods.include?(:baz)
    end

    def test_including_class_methods
      assert_equal WithTestModule.bar, :bar_class
      assert_equal WithTestModule.foz, :foo_class
      assert_raises(NoMethodError) { WithTestModule.foo }
      assert_raises(NoMethodError) { WithTestModule.foo_bar }
    end

    def test_including_anonymous_class_methods_module_in_acestors
      class_method_module = (class << WithTestModule; self.included_modules; end).first

      assert_equal class_method_module.name, nil

      methods = class_method_module.instance_methods
      assert methods.include?(:bar)
      assert methods.include?(:foz)
    end

    def test_included_block
      assert WithTestModule.included_ran
    end
  end

  class IncludingNested < Minitest::Test
    class WithNestedTestModule
      extend IncludeModule
      include_module NestedTestModule, instance_methods: :all, class_methods: :all, included: true
    end

    def test_including_instance_methods
      instance = WithNestedTestModule.new

      assert_equal instance.foo, :foo_instance
      assert_equal instance.bar, 'bar + bar_instance'
      assert_equal instance.bar2, 'bar + bar_instance + bar2'
    end

    def test_adding_module_in_acestors
      included_modules = WithNestedTestModule.included_modules

      assert included_modules.include?(IncludeModuleTest::NestedTestModule)
      assert included_modules.include?(IncludeModuleTest::TestModule)
    end

    def test_including_class_methods
      assert_equal WithNestedTestModule.bar, :bar_class
      assert_equal WithNestedTestModule.foo, 'foo + foo_class'
    end

    def test_adding_class_methods_module_in_acestors
      class_method_modules = class << WithNestedTestModule; self.included_modules; end

      assert class_method_modules.include?(IncludeModuleTest::NestedTestModule::ClassMethods)
      assert class_method_modules.include?(IncludeModuleTest::TestModule::ClassMethods)
    end

    def test_included_blocks
      assert_equal WithNestedTestModule.included_ran2, 'included'
      assert_equal WithNestedTestModule.included_ran, nil
    end
  end

  class IncludingDeeplyNested < Minitest::Test
    class WithDeeplyNestedTestModule
      extend IncludeModule
      include_module NestedModule3, instance_methods: :all, class_methods: :all, included: true
    end

    def test_including_instance_methods
      instance = WithDeeplyNestedTestModule.new

      assert_equal instance.foo, 'foo1 + foo2 + foo3'
    end

    def test_adding_module_in_acestors
      included_modules = WithDeeplyNestedTestModule.included_modules

      assert included_modules.include?(IncludeModuleTest::NestedModule3)
      assert included_modules.include?(IncludeModuleTest::NestedModule2)
      assert included_modules.include?(IncludeModuleTest::TestModule1)
    end

    def test_including_class_methods
      assert_equal WithDeeplyNestedTestModule.bar, 'bar1 + bar21 + bar31 + bar22 + bar32'
    end

    def test_adding_class_methods_in_acestors_and_included_block
      class_method_modules = class << WithDeeplyNestedTestModule; self.included_modules; end

      assert class_method_modules.include?(IncludeModuleTest::NestedModule3::ClassMethods)
      assert class_method_modules.include?(IncludeModuleTest::NestedModule2::ClassMethods)
      assert class_method_modules.include?(IncludeModuleTest::TestModule1::ClassMethods)
    end
  end

  class BuiltInIncluding < Minitest::Test
    class WithTestModule
      extend IncludeModule
      include TestClassicModule
    end

    def test_including_instance_methods
      instance = WithTestModule.new

      assert_equal instance.foo, :foo_instance
      assert_equal instance.bar, :bar_instance
      assert_raises(NoMethodError) { instance.baz }
    end

    def test_adding_module_in_acestors
      assert WithTestModule.included_modules.include?(IncludeModuleTest::TestClassicModule)
      assert WithTestModule.ancestors.include?(IncludeModuleTest::TestClassicModule)
    end

    def test_including_class_methods
      assert_equal WithTestModule.bar, :bar_class
      assert_equal WithTestModule.foo, :foo_class
      assert_raises(NoMethodError) { WithTestModule.foz }
    end

    def test_adding_class_methods_module_in_acestors
      class_method_modules = class << WithTestModule; self.included_modules; end

      assert class_method_modules.include?(IncludeModuleTest::TestClassicModule::ClassMethods)
    end
  end
end
