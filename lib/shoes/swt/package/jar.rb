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

        def package(path)
          @jar.apply @config
          @jar.create path.to_s
        end
      end
    end
  end
end
