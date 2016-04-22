abstract class Action
  abstract def run(context : Context, to_name, *args)
end
