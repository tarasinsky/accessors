module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    SAVED_HISTORY_VAR = '@saved_history'.freeze
    def attr_accessor_with_history(*methods)
      methods.each do |method|
        raise TypeError.new("method name is not symbol") unless method.is_a?(Symbol)

        define_method(method) { instance_variable_get("@#{method}") }
        
        define_method("#{method}=") do |value|
          prev_value = instance_variable_get("@#{method}")

          instance_variable_set("@#{method}", value)

          instance_variable_set(SAVED_HISTORY_VAR, {}) unless instance_variable_defined?(SAVED_HISTORY_VAR)
          saved_history = instance_variable_get(SAVED_HISTORY_VAR)
          saved_history[method] = [] unless saved_history[method].is_a?(Array)
          saved_history[method] << prev_value
          instance_variable_set(SAVED_HISTORY_VAR, saved_history)
        end

        define_method("#{method}_history") { instance_variable_get(SAVED_HISTORY_VAR)[method] }
      end
    end

    def strong_attr_accessor(attr_name, attr_class)
      attr_sym = attr_name.to_sym
      define_method(attr_sym) { instance_variable_get("@#{attr_sym}") }
      
      define_method("#{attr_name}=") do |value|
        if value.is_a?(attr_class)
          instance_variable_set("@#{attr_name}", value)
        else
          raise TypeError.new("Wrong class #{value.class} for #{value}, not #{attr_class}")
        end
      end
    end
  end
end
