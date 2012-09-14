# Shoes-warbler

This is an experiment with using [Warbler](https://github.com/jruby/warbler) to package a Shoes 4 app.

## Setup your environment

    rvm use jruby-1.6.7
    rvm gemset create shoes-warbler
    rvm use jruby-1.6.7@shoes-warbler
    gem install bundle && bundle install    

    
## Get started

Consider this a proof of concept. You can personalize as you wish.

- an example Shoes 4 app at `bin/hello_from_warbler`. This can be any Shoes 4
  app. Just follow the template. Make sure your app does not have an extension (Warbler doesn't like that).
- a `project.gemspec`. Make sure that your Shoes 4 app is included in the list of executables, and that the
  `shoes` gem is included in your list of dependencies.
- a `bin/package` packager. This will package your Shoes 4 app plus dependencies into a .jar in the project root.
- a `vendor` directory, containing git submodules that track custom versions of dependencies (changes
  haven't been merged upstream yet).


## Configure your app

Edit the `app.yaml` file. Currently, the only option is `name`, which will become the name of your .jar.

## Package and run your app

    $ bin/package
    $ java -XstartOnFirstThread -Djruby.compat.version=1.9 -jar shoes-warbler.jar

where `shoes-warbler.jar` is the name of your .jar.

