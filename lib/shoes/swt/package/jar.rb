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

        def package(path = default_path)
          @jar.apply @config
          @jar.create path.to_s
          path.to_s
        end

        def default_path
          File.join('pkg', "#{@config.jar_name}.#{@config.jar_extension}")
        end
      end
    end
  end
end
