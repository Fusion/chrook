# chrook

A terrible name.

## Installation


TODO: Write installation instructions here

## TODO

- Severe limitation for now: when executing a command using ssh2 runner,
  a maximum read size of 32k is expected.
- I really need to start adding comments!

## Usage

yml syntax:

* A yml file can contain multiple epics in array form
* Each epic must come with a hosts array
* Expansion/extrapolation takes place even when listing hosts
* Expansion: #@: = executable js code; #@:arg1=val arg2=val ...: same with timeout

### Expansions

Execute

    <section name>: |
      @#:
      code

Execute with arguments

    <section name>: |
      @#: timeout=500:
      code

Substitute variable (raw)

    <section name>: |
      @v:
      var_name

Substitute variable (literal)

    <section name>: |
      {{var_name}}

### Variables

Assign variable

    section:
      - var: var_name
        value: |
          var_content

### Environment

Dump environment

    section:
      - dump_env:

Using when executing code:

    env.$.hosts.forEach(function(item) {
      print("Host: " + item.name);
    })

    print(env["host_name"].variable_name)
    // or
    print(env.host_name.variable_name)

### Stories

In a given story, each action that takes place on hosts will be run fully on all hosts as defined by the 'hosts' directive and the story will only move forward when all hosts have performed that command.

### Security

#### SSH Access

Should be possible using either username/password or, better, username + key

* Generate your key, if you have not done so yet: `ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`
* Push your key to the managed device using `security_push_key <pub_key_file>`

#### sudo/etc

Use `become`

Again, for flexibility it is easier if the user is an sudoer with no required password.
After all, why require a password when you are in automated mode?

Note that this will only work if the account you are modifying is already a member of the 'sudo' group.

Update security this way:

    TODO

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/ansiblelikepg/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) Chris F Ravenscroft - creator, maintainer
