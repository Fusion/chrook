require "../action.cr"

class FileContains  < Action
  def run(context : Context, run_as, *args)
  end

end

register_action "file_contains", FileContains
