require 'rubygems'
require 'yaml'
require 'warbler'
require 'warbler/traits/shoes'

module Shoes
  module Swt
    module Package
      class Jar
        def initialize
          @jar = Warbler::Jar.new
        end

        def apply(config)
          @jar.apply(config)
        end

        def create(config)
          @jar.create(config)
        end
      end
    end
  end
end
