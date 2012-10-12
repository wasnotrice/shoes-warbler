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
APP_NAME = CONFIG.name
APP = "#{APP_NAME}.app"
JAR = "#{CONFIG.shortname}.jar"
app = Shoes::Swt::Package::App.new(CONFIG)
APP_TEMPLATE_ZIP = ENV['SHOES_APP_TEMPLATE'] || app.default_template_path.to_s
TEMPLATES = File.dirname(APP_TEMPLATE_ZIP)
APP_TEMPLATE = "#{TEMPLATES}/#{File.basename(APP_TEMPLATE_ZIP, '.zip')}.app"

directory PKG
directory TEMPLATES

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
    task :extract => TEMPLATES do
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
      ENV['SHOES_APP_NAME'] = APP_NAME
      ENV['SHOES_APP_ICON'] = CONFIG.icons[:osx]

      # Generate APP
      ant '-f build.xml shoes-app'

      # The template is smaller without JARs
      rm_rf "#{APP}/Contents/Java"
      mkdir_p "#{APP}/Contents/Java"

      rm_rf APP_TEMPLATE
      mv APP, APP_TEMPLATE
    end

    task :clean do
      rm_rf APP
      rm_rf APP_TEMPLATE
      rm_rf APP_TEMPLATE_ZIP
    end

    task :zip => APP_TEMPLATE_ZIP do
      rm_rf APP_TEMPLATE
    end

    file APP_TEMPLATE_ZIP => APP_TEMPLATE do
      require 'shoes/package/zip_directory'
      rm_rf APP_TEMPLATE_ZIP
      zipfile = ::Shoes::Package::ZipDirectory.new(APP_TEMPLATE, APP_TEMPLATE_ZIP)
      zipfile.write
    end

    file APP_TEMPLATE => [TEMPLATES] do
      Rake::Task['app:template:generate'].invoke
    end
  end

  desc "Inject a JAR into the APP template"
  task :inject => APP_TEMPLATE_ZIP do
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
