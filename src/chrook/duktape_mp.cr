module Duktape
  class Runtime
    private def push_crystal_object(arg : Array(YAML::Type))
      array_index = @context.push_array
      arg.each_with_index do |object, index|
        push_crystal_object object
        @context.put_prop_index array_index, index.to_u32
      end
    end

    private def push_crystal_object(arg : Hash(YAML::Type, YAML::Type))
      @context.push_object
      arg.each do |key, value|
        @context.push_string key.to_s
        push_crystal_object value
        @context.put_prop -3
      end
    end
  end
end
