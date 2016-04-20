require "../action.cr"

class Cmd  < Action
  def run(context : Context, *args)
    context.runners.traverse do |runner|
      runner.execute args
    end
  end
end

register_action "cmd", Cmd
