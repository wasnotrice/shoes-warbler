$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rake/clean'
require 'ant'
require 'yaml'
require 'shoes/package/configuration'
require 'shoes/swt/package/app'

DEPS = FileList['vendor/*']
CLEAN.include '*.app', '*.jar', 'pkg'
CLEAN.exclude 'Shoes Template.app'
CLOBBER.include 'doc'
CONFIG = Shoes::Package::Configuration.load
PKG = 'pkg'
APP = "#{CONFIG.name}.app"
APP_EXECUTABLE = "#{APP}/Contents/MacOs/JavaAppLauncher"
APP_ICON_OSX = CONFIG.icons[:osx].pathmap "#{APP}/Contents/Resources/%f"
JAR = "#{CONFIG.shortname}.jar"
app = Shoes::Swt::Package::App.new(CONFIG)
SHOES_APP_TEMPLATE = ENV['SHOES_APP_TEMPLATE'] ? Pathname.new(ENV['SHOES_APP_TEMPLATE']) : Pathname.new("#{app.default_template_path.basename('.zip')}.app")
SHOES_APP_TEMPLATE_ZIP = Pathname.new("#{SHOES_APP_TEMPLATE.basename('.app')}.zip")
SHOES_APP_TEMPLATE_NAME = "Example Shoes App"

directory PKG

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

task :app => 'app:inject'
task 'app:template' => 'app:template:zip'

namespace :app do
  namespace :template do
    task :extract do
      Shoes::Swt::Package::App.new(CONFIG).extract_template
    end

    desc "Package a JAR as an APP (only available on OS X)"
    task :generate => :jar do
      fail "Only available on OS X" unless RbConfig::CONFIG['host_os'] =~ /darwin/
      # Oracle JDK
      #ENV['JDK_HOME'] = "/Library/Java/JavaVirtualMachines/jdk1.7.0_07.jdk/Contents/Home"
      # OpenJDK
      ENV['JDK_HOME'] = "/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home"
      ENV['SHOES_JAR_NAME'] = CONFIG.shortname
      ENV['SHOES_APP_NAME'] = SHOES_APP_TEMPLATE_NAME
      ENV['SHOES_APP_ICON'] = CONFIG.icons[:osx]
      ant '-f build.xml shoes-app'
      mv SHOES_APP_TEMPLATE, SHOES_APP_TEMPLATE.pathmap('%p.backup') if File.exist?(SHOES_APP_TEMPLATE)
      mv "#{SHOES_APP_TEMPLATE_NAME}.app", SHOES_APP_TEMPLATE
    end

    task :zip => SHOES_APP_TEMPLATE_ZIP

    file SHOES_APP_TEMPLATE_ZIP => SHOES_APP_TEMPLATE do
      require 'shoes/package/zip_directory'
      rm_rf SHOES_APP_TEMPLATE_ZIP
      zipfile = ::Shoes::Package::ZipDirectory.new(SHOES_APP_TEMPLATE, SHOES_APP_TEMPLATE_ZIP)
      zipfile.write
    end

    file SHOES_APP_TEMPLATE => 'app:template:generate'
  end

  desc "Inject a JAR into the APP template"
  task :inject => APP

  file APP do
    require 'shoes/swt/package/app'
    app = Shoes::Swt::Package::App.new(CONFIG)
    app.package
  end
end

desc "Package as a JAR"
task :jar => JAR

file JAR => PKG do
  require 'shoes/swt/package/jar'
  Shoes::Swt::Package::Jar.new.package
end
