require 'shoes/package/configuration'

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
        custom_config = YAML.load(File.read 'app.yaml')
        @app_config = ::Shoes::Package::Configuration.new(custom_config)
        config.jar_name = @app_config.shortname
        config.pathmaps.application = ['shoes-app/%p']
        specs = @app_config.gems.map { |g| Gem::Specification.find_by_name(g) }
        dependencies = specs.map { |s| s.runtime_dependencies }.flatten
        (specs + dependencies).uniq.each { |g| config.gems << g }
        config.excludes += FileList[*@app_config.ignore].pathmap(config.pathmaps.application.first)
      end

      def after_configure
        config.init_contents << StringIO.new("require 'shoes'\nShoes.configuration.backend = :swt\n")
      end

      def update_archive(jar)
        # Not sure why Warbler doesn't do this automatically
        jar.files.delete_if { |k, v| @config.excludes.include? k }
        add_main_rb(jar, apply_pathmaps(config, default_executable, :application))
      end

      # Uses the `@app_config.run` if it exists. Otherwise, looks in the
      # application's `bin` directory for an executable with the same name as
      # the jar. If this also fails, defaults to the first executable (alphabetically) in the
      # applications `bin` directory.
      #
      # @return [String] filename of the executable to run
      def default_executable
        return @app_config.run.split('\s').first if @app_config.run
        exes = Dir['bin/*'].sort
        exe = exes.grep(/#{config.jar_name}/).first || exes.first
        raise "No executable script found" unless exe
        exe
      end
    end
  end
end
