module Section extend self
  def parse(@@context, text)
    context = @@context.not_nil!
    text.each do |subsection|
      case subsection.raw
      when Hash(YAML::Type, YAML::Type)
        sub = subsection.raw as Hash(YAML::Type, YAML::Type)
        action, arg = sub.first
        case action
        when "var"
          varname = arg
          if sub.has_key? "value"
              context.variables.set varname, sub["value"]
          else
            abort "No value specified for variable '#{varname}'"
          end
        when "become"
          # Valid values: <username> | super | self
          context.persona = arg
        when "dump_env"
          puts context.variables.raw.inspect
        else
          custom = get_action action.to_s
          abort "Unknown custom action: #{action}" if custom == nil
          custom.run context, action.to_s, Extrapolator.parse context, Raw.new arg
          # #InProgress:0 Introduce 'condition?' -> then: or if: issue:4
          if sub.has_key? "to"
            context.variables.each_space do |space, v|
              context.variables.instance_set space, sub["to"], v["result"]
            end
          end
        end
      when Array(YAML::Type)
        p "TODO!!!"
      else
        abort "Not implemented yet in Section.cr"
      end
    end
  end
end
