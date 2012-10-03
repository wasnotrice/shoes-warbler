module Warbler
  module Traits
    class Shoes
      include Trait
      include PathmapHelper

      def self.detect?
        File.exist? "app.yaml"
      end

      def self.requires?(trait)
        # Actually, it would be better to dump the NoGemspec trait, but since
        # we can't do that, we can at least make sure that this trait gets
        # processed later by declaring that it requires NoGemspec.
        [Traits::Jar, Traits::NoGemspec].include? trait
      end

      def before_configure
        @app = { name: 'Shoes App' }
        @app.update YAML.load(File.read 'app.yaml')
        @app['ignore'] = Array(@app['ignore'])
        @app['gems'] = Array(@app['gems']) << 'shoes'
        @app['shortname'] ||= @app['name'].downcase.gsub(/\W+/, '')

        puts @app['gems']

        config.jar_name = @app['shortname']
        config.pathmaps.application = ['shoes-app/%p']
        specs = @app['gems'].map { |g| Gem::Specification.find_by_name(g) }
        dependencies = specs.map { |s| s.runtime_dependencies }.flatten
        (specs + dependencies).uniq.each { |g| config.gems << g }
        config.excludes += FileList[*Array(@app['ignore'])].pathmap(config.pathmaps.application.first)
      end

      def after_configure
      end

      def update_archive(jar)
        # Not sure why Warbler doesn't do this automatically
        jar.files.delete_if { |k, v| @config.excludes.include? k }
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
