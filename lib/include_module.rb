module IncludeModule
  def include_module(new_module, instance_methods: [], class_methods: [], included: true)
    if is_a?(Class)
      __include_class_methods_in_class(new_module: new_module, method_names: class_methods)
      __include_included_blocks_in_class(new_module: new_module, included: included)
    else
      __include_class_methods_in_module(new_module: new_module, method_names: class_methods)
      __store_included_block_in_module(new_module: new_module, included: included)
    end

    __include_instance_methods(new_module: new_module, method_names: instance_methods)
  end

  private

  def __include_class_methods_in_class(new_module:, method_names:)
    new_class_methods_module = __class_methods_module(new_module)
    return unless new_class_methods_module

    if method_names == :all
      extend new_class_methods_module
    else
      extend __map_module!(new_module: new_class_methods_module.dup, method_names: method_names)
    end
  end

  def __include_class_methods_in_module(new_module:, method_names:)
    new_class_methods_module = __class_methods_module(new_module)
    return unless new_class_methods_module

    __include_instance_methods(
      new_module: new_class_methods_module,
      method_names: method_names,
      include_in: __class_methods_module(self)
    )
  end

  def __include_included_blocks_in_class(new_module:, included:)
    return unless included

    included_blocks = new_module.instance_variable_get(:@__included_blocks) || []
    included_blocks += [new_module::INCLUDED] if new_module.const_defined?(:INCLUDED)
    included_blocks.each { |included_block| class_eval(&included_block) }
  end

  def __store_included_block_in_module(new_module:, included:)
    return unless included

    @__included_blocks = new_module.instance_variable_get(:@__included_blocks) || []
    @__included_blocks << new_module::INCLUDED if new_module.const_defined?(:INCLUDED)
  end

  def __include_instance_methods(new_module:, method_names:, include_in: self)
    if method_names == :all
      include_in.include(new_module)
    else
      new_mapped_module = __map_module!(new_module: new_module.dup, method_names: method_names)
      include_in.include(new_mapped_module)
    end
  end

  def __map_module!(new_module:, method_names:)
    new_method_names = __method_names_mapping(method_names)

    new_module.instance_methods.each do |method_name|
      new_method_name = new_method_names[method_name]

      case new_method_name
      when method_name # leave it as is
      when nil         # remove
        new_module.class_eval { remove_method(method_name) }
      else             # rename
        new_module.class_eval { alias_method(new_method_name, method_name); remove_method(method_name) }
      end
    end

    new_module
  end

  def __method_names_mapping(method_names)
    method_names.each_with_object({}) do |method_name, result|
      if method_name.is_a?(Hash)
        result.merge!(method_name)
      else
        result[method_name] = method_name
      end
    end
  end

  def __class_methods_module(new_module)
    if new_module.const_defined?(:ClassMethods)
      new_module.const_get(:ClassMethods)
    else
      new_module.const_set(:ClassMethods, Module.new)
    end
  end
end
