module Warbler
  module Traits
    class Shoes
      include Trait
      include PathmapHelper

      def self.detect?
        File.exist? "app.yaml"
      end

      def self.requires?(trait)
        trait == Traits::Jar
      end

      def before_configure
        @app = {
          name: 'Shoes App',
          ignore: []
        }
        @app.update YAML.load(File.read 'app.yaml')
        @app['shortname'] ||= @app['name'].downcase.gsub(/\W+/, '')

        config.jar_name = @app['shortname']
        config.pathmaps.application = ['shoes-app/%p']
        config.excludes += FileList[*Array(@app['ignore'])].pathmap(config.pathmaps.application.first)
      end

      def after_configure
      end

      def update_archive(jar)
        add_main_rb(jar, apply_pathmaps(config, default_executable, :application))
      end

      def default_executable
        return @app['run'].split('\s').first if @app['run']
        exes = Dir['bin/*'].sort
        exe = exes.grep(/#{config.jar_name}/).first || exes.first
        raise "No executable script found" unless exe
        exe
      end
    end
  end
end
