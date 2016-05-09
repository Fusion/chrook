require "../action.cr"

class FileContains  < Action
  def provides
    "Does nothing for now"
  end

  def run(context : Context, run_as, *args)
  end

end

register_action "file_contains", FileContains
