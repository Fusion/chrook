require "../action.cr"

class Display < Action
  def provides
    "Display a message to console"
  end

  def run(context : Context, run_as, *args)
    puts "Message: #{args[0]}"
  end

end

register_action "display", Display
