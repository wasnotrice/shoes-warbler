# Shoes-warbler

This is an experiment with using [Warbler](https://github.com/jruby/warbler) to package a Shoes 4 app.

## Get started

Consider this a proof of concept. You can replace the Shoes app and the gemspec as you wish.

- an example Shoes 4 app at `bin/hello_from_warbler`. This can be any Shoes 4
  app. Just follow the template. Make sure your app does not have an extension.
- a `project.gemspec`. Make sure that your Shoes 4 app is included in the list of executables.
- a `bin/package` packager. This will package your Shoes 4 app plus dependencies into a .jar in the project root.

## Package and run your app

    $ bin/package
    $ java -XstartOnFirstThread -Djruby.compat.version=1.9 -jar shoes-warbler.jar

where `shoes-warbler.jar` is the name of your .jar.
