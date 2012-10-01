# Shoes-warbler

This is an experiment with using [Warbler](https://github.com/jruby/warbler) and the [Java Application Bundler](http://java.net/projects/appbundler) to package a Shoes 4 app.

## Prerequisites

You need the Java 7 JDK and Apache Ant installed.

## Setup your environment

You may have to supplement these instructions :)

1. Install jruby and create a gemset for this project

        rvm install jruby
        rvm gemset create shoes-warbler
        rvm use jruby-1.6.7@shoes-warbler

2. Setup git submodules

        git submodule init
        git submodule update

3. Build and install dependencies

        rake deps
        
## Get started

Consider this a proof of concept. You can personalize as you wish. You get:

- an example Shoes 4 app at `bin/hello_from_warbler`. This can be replaced with any Shoes 4
  app. Just follow the template. Make sure your app does not have an extension (Warbler doesn't like that).
- a `project.gemspec`. Make sure that your Shoes 4 app is included in the list of executables, and that the
  `shoes` gem is included in your list of dependencies.
- a `bin/package` packager. This will package your Shoes 4 app plus dependencies into a .jar in the project root.
- a `vendor` directory, containing
    - git submodules that track custom versions of dependencies (changes haven't been merged upstream yet).
    - the Java Application Bundler Ant tasks



## Configure your app

Edit the `app.yaml` file. Currently, the only option is `name`, which will become the name of your JAR.

## Package your app as a JAR

    $ rake jar
    $ java -XstartOnFirstThread -Djruby.compat.version=1.9 -jar test-app.jar

where `test-app.jar` is the name of your JAR (as specified in your `app.yaml` file)

## Package your app a Mac APP

    $ rake app
    $ open Test.app

For now, the app is always called `Test.app`, no matter what your JAR is called. 

