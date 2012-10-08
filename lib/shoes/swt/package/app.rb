require 'shoes/package/configuration'
require 'shoes/package/zip_directory'

module Shoes
  module Swt
    module Package
      class App
        # @param [Shoes::Package::Configuration] config user
        #   configuration
        def initialize(config, template_path)
          @config = config
          @default_package_path = Pathname.new('pkg').join("#{@config.name}.app")
          #@template_path ||= Pathname.new(__FILE__).join('../../..'
        end

        def package(path = @default_package_path)
          require 'fileutils'
          FileUtils.touch path
        end

        def copy_template
        end
      end
    end
  end
end
