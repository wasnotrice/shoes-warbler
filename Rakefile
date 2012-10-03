$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rake/clean'
require 'ant'
require 'yaml'

DEPS = FileList['vendor/*']
CLEAN.include '*.app', '*.jar'
CLEAN.exclude 'Shoes Template.app'
APP = YAML.load(File.open 'app.yaml')
APP_FILENAME = "#{APP['name']}.app"
JAR = "#{APP['shortname']}.jar"

desc "Build and install custom dependencies"
task :deps do
  DEPS.each do |dep|
    next unless File.directory?(dep)
    cd dep do
      sh "gem build #{dep.pathmap('%f.gemspec')}"
    end
    gemfile = FileList["#{dep}/#{dep.pathmap('%f')}-*.gem"].first
    sh "gem install #{gemfile}"
    rm_f gemfile
  end
end

desc "Package a JAR as an APP"
task :app => :jar do
  ENV['JAVA_HOME'] = "/Library/Java/JavaVirtualMachines/jdk1.7.0_07.jdk/Contents/Home"
  ENV['SHOES_APP_NAME'] = APP['shortname']
  ant '-f build.xml shoes-app'
end

desc "Package as a JAR"
task :jar => JAR

file JAR do
  require 'shoes/swt/package/jar'

  jar = Shoes::Swt::Package::Jar.new
  config = Warbler::Config.new
  jar.apply(config)
  jar.create(config)
end
