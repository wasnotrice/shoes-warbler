$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rake/clean'
require 'ant'
require 'yaml'
require 'shoes/package/configuration'
require 'shoes/swt/package/app'

DEPS = FileList['vendor/*']
CLEAN.include '*.app', '*.jar', 'pkg'
CLEAN.exclude 'Shoes Template.app'
CONFIG = Shoes::Package::Configuration.new(YAML.load(File.open 'app.yaml'))
APP = "#{CONFIG.name}.app"
APP_EXECUTABLE = "#{APP}/Contents/MacOs/JavaAppLauncher"
APP_ICON_OSX = CONFIG.icons[:osx].pathmap "#{APP}/Contents/Resources/%f"
JAR = "#{CONFIG.shortname}.jar"
SHOES_APP_TEMPLATE = ENV['SHOES_APP_TEMPLATE'] || "static/shoes-app-template.app"
SHOES_APP_TEMPLATE_ZIP = "#{SHOES_APP_TEMPLATE}.zip"
SHOES_APP_TEMPLATE_NAME = "Example Shoes App"

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

namespace :app do
  namespace :template do
    task :extract do
      Shoes::Swt::Package::App.new(CONFIG).extract_template
    end

    desc "Package a JAR as an APP (only available on OS X)"
    task :generate => :jar do
      fail "Only available on OS X" unless RbConfig::CONFIG['host_os'] =~ /darwin/
      #ENV['JAVA_HOME'] = "/Library/Java/JavaVirtualMachines/jdk1.7.0_07.jdk/Contents/Home"
      ENV['JDK_HOME'] = "/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home"
      ENV['SHOES_JAR_NAME'] = CONFIG.shortname
      ENV['SHOES_APP_NAME'] = SHOES_APP_TEMPLATE_NAME
      ENV['SHOES_APP_ICON'] = CONFIG.icons[:osx]
      ant '-f build.xml shoes-app'
      mv SHOES_APP_TEMPLATE, SHOES_APP_TEMPLATE.pathmap('%p.backup') if File.exist?(SHOES_APP_TEMPLATE)
      mv "#{SHOES_APP_TEMPLATE_NAME}.app", SHOES_APP_TEMPLATE
    end

    task :zip => SHOES_APP_TEMPLATE_ZIP
    require 'shoes/package/zip_directory'

    file SHOES_APP_TEMPLATE_ZIP => SHOES_APP_TEMPLATE do
      rm_rf SHOES_APP_TEMPLATE_ZIP
      zipfile = ::Shoes::Package::ZipDirectory.new(SHOES_APP_TEMPLATE, SHOES_APP_TEMPLATE_ZIP)
      zipfile.write
    end
  end

  desc "Inject a JAR into an APP template"
  task :inject => ['app:inject_jar', 'app:inject_config']

  task :copy_template => APP do
    chmod 0755, APP_EXECUTABLE
  end

  file APP => [SHOES_APP_TEMPLATE] do |t|
    cp_r t.prerequisites.first, t.name
  end

  task :inject_icon => APP_ICON_OSX

  file APP_ICON_OSX => :copy_template do |t|
    rm_rf APP_ICON_OSX.pathmap('%d/GenericApp.icns')
    cp CONFIG.icons[:osx], APP_ICON_OSX
    # Encourage Finder to reload icon
    touch APP
  end

  task :inject_jar => [:jar, :copy_template] do
    jar_dir = "#{APP}/Contents/Java"
    rm_rf "#{jar_dir}/*"
    cp JAR, "#{jar_dir}/"
  end
end

desc "Package as a JAR"
task :jar => JAR

file JAR do
  require 'shoes/swt/package/jar'

  Shoes::Swt::Package::Jar.new.package
end
