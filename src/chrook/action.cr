abstract class Action
  abstract def run(context : Context, run_as, *args)
  abstract def provides
end
