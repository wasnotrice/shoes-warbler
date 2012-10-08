require 'warbler'
require 'warbler/traits/shoes'

module Shoes
  module Swt
    module Package
      class Jar
        def initialize
          @jar = Warbler::Jar.new
          @shoes_config = ::Shoes::Package::Configuration.load
          @config = Warbler::Config.new do |config|
            # Customize Warbler config here
          end
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
      end
    end
  end
end
