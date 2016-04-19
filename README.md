# chrook

A terrible name.

## Installation


TODO: Write installation instructions here


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

### Stories

In a given story, each action that takes place on hosts will be run fully on all hosts as defined by the 'hosts' directive and the story will only move forward when all hosts have performed that command.

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
