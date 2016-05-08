require "../action.cr"

class PushKey  < Action
  def run(context : Context, run_as, *args)
    key_content = File.read context.file_name args[0].to_s
    dest_dir = "~/.ssh"
    dest_file = "#{dest_dir}/authorized_keys"
    context.runners.traverse do |runner|
      runner.execute [ "mkdir #{dest_dir}; chmod 700 #{dest_dir}; [[ -z $(grep '#{key_content}' #{dest_file}) ]] && echo '#{key_content}' >> #{dest_file}; chmod 644 #{dest_file}" ]
    end
  end
end

register_action "push_key", PushKey
