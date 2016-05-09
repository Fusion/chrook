require "../action.cr"

class SecurityPushKey  < Action
  def provides
    "Push SSH key to remote host for future password-less connections"
  end

  def run(context : Context, run_as, *args)
    key_content = File.read context.file_name args[0].to_s
    dest_dir = "~/.ssh"
    dest_file = "#{dest_dir}/authorized_keys"
    context.runners.traverse do |runner|
      runner.execute [ "mkdir #{dest_dir}; chmod 700 #{dest_dir}; [[ -z $(grep '#{key_content}' #{dest_file}) ]] && echo '#{key_content}' >> #{dest_file}; chmod 644 #{dest_file}" ]
    end
  end
end

class SecurityPassword < Action
  def provides
    "Instruct remote host to allow password-less sudo's from now on. Only takes one argument, to avoid catastrophic deletion of sudoers file: 'no'"
  end

  def run(context : Context, run_as, *args)
    abort "Only 'no' argument is supported by 'security_password'" if args[0].to_s != "no"

    dest_file = "/etc/sudoers"
    context.runners.traverse do |runner|
      user_name = runner.hostinfo.username
      password  = runner.hostinfo.password
      runner.execute [ "[[ -z $(echo \"#{password}\" | sudo -S grep \"^#{user_name} \" #{dest_file}) ]] && echo \"#{password}\" | sudo -S sh -c \"chmod 660 #{dest_file}; echo '#{user_name} ALL=(ALL) NOPASSWD:ALL' >> #{dest_file}; chmod 440 #{dest_file}\"" ]
    end
  end
end

register_action "security_push_key", SecurityPushKey
register_action "security_password", SecurityPassword
