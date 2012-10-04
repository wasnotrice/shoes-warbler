require 'warbler'
require 'warbler/traits/shoes'

module Shoes
  module Swt
    module Package
      class Jar
        def initialize
          @jar = Warbler::Jar.new
          @config = Warbler::Config.new
        end

        def package(config = @config)
          @jar.apply config
          @jar.create config
        end
      end
    end
  end
end
