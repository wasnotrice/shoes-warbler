require 'warbler'
require 'warbler/traits/shoes'

module Shoes
  module Swt
    module Package
      class Jar
        def initialize(config = nil)
          @jar = Warbler::Jar.new
          @shoes_config = config || ::Shoes::Package::Configuration.load
          @config = Warbler::Config.new do |config|
            config.jar_name = @shoes_config.shortname
            config.pathmaps.application = ['shoes-app/%p']
            specs = @shoes_config.gems.map { |g| Gem::Specification.find_by_name(g) }
            dependencies = specs.map { |s| s.runtime_dependencies }.flatten
            (specs + dependencies).uniq.each { |g| config.gems << g }
            config.excludes.add FileList[*@shoes_config.ignore].pathmap(config.pathmaps.application.first)
          end
          @config.extend ShoesWarblerConfig
          @config.run = @shoes_config.run.split(/\s/).first
        end

        def package(dir = default_dir)
          @jar.apply @config
          path = File.join(dir.to_s, filename)
          @jar.create path
          path
        end

        def default_dir
          'pkg'
        end

        def filename
          "#{@config.jar_name}.#{@config.jar_extension}"
        end

        private
        # Adds Shoes-specific functionality to the Warbler Config
        module ShoesWarblerConfig
          attr_accessor :run
        end
      end
    end
  end
end
