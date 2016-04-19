module Section extend self
  def parse(@@context, text)
    text.each do |subsection|
      case subsection.raw
      when Hash(YAML::Type, YAML::Type)
        sub = subsection.raw as Hash(YAML::Type, YAML::Type)
        action, arg = sub.first
        case action
        when "var"
          varname = arg
          if sub.has_key?("value")
              @@context.not_nil!.variables.set(varname, sub["value"])
          else
            abort "No value specified for variable '#{varname}'"
          end
        else
          custom = get_action action.to_s
          abort "Unknown custom action: #{action}" if custom == nil
          custom.run @@context.not_nil!, arg
        end
      when Array(YAML::Type)
        p "TODO!!!"
      else
        abort "Not implemented yet in Section.cr"
      end
    end
  end
end
