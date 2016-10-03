module IncludeModule
  def extend_module(new_module, methods: [])
    return if methods.empty?
    __extend_methods(new_module: new_module, method_names: methods)
  end

  def include_module(new_module, methods: [], included: false)
    if is_a?(Class)
      __include_included_blocks(new_module: new_module, included: included)
    elsif is_a?(Module)
      __store_included_block(new_module: new_module, included: included)
    end

    return if methods.empty?
    __include_methods(new_module: new_module, method_names: methods)
  end

  private

  def __extend_methods(new_module:, method_names:)
    if method_names == :all
      extend(new_module)
    else
      new_mapped_module = __map_module_methods!(new_module: new_module.dup, method_names: method_names)
      extend(new_mapped_module)
    end
  end

  def __include_included_blocks(new_module:, included:)
    return unless included

    included_blocks = new_module.instance_variable_get(:@__included_blocks) || []
    included_blocks << new_module::INCLUDED if new_module.const_defined?(:INCLUDED)
    included_blocks.each { |included_block| class_eval(&included_block) }
  end

  def __store_included_block(new_module:, included:)
    return unless included

    @__included_blocks = new_module.instance_variable_get(:@__included_blocks) || []
    @__included_blocks << new_module::INCLUDED if new_module.const_defined?(:INCLUDED)
  end

  def __include_methods(new_module:, method_names:)
    if method_names == :all
      include(new_module)
    else
      new_mapped_module = __map_module_methods!(new_module: new_module.dup, method_names: method_names)
      include(new_mapped_module)
    end
  end

  def __map_module_methods!(new_module:, method_names:)
    new_method_name_by_original_method_name = __new_method_name_by_original_method_name(method_names)

    new_module.instance_methods.each do |original_method_name|
      new_method_name = new_method_name_by_original_method_name[original_method_name]

      case new_method_name
      when original_method_name # leave it as is
      when nil                  # remove
        new_module.class_eval { remove_method(original_method_name) }
      else                      # rename
        new_module.class_eval do
          alias_method(new_method_name, original_method_name)
          remove_method(original_method_name)
        end
      end
    end

    new_module
  end

  def __new_method_name_by_original_method_name(method_names)
    method_names.each_with_object({}) do |method_name, result|
      if method_name.is_a?(Hash)
        result.merge!(method_name)
      else
        result[method_name] = method_name
      end
    end
  end
end
