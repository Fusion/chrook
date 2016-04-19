require "../action.cr"

class Cmd  < Action
  def run(context : Context, *args)
    context.runners.run do |host|
      p host
    end
  end
end

register_action "cmd", Cmd
