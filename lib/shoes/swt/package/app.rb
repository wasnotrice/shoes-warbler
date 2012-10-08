require 'shoes/package/configuration'
require 'shoes/package/zip_directory'
require 'fileutils'

module Shoes
  module Swt
    module Package
      class App
        include FileUtils

        # @param [Shoes::Package::Configuration] config user
        #   configuration
        def initialize(config)
          @config = config
          @default_package_dir = Pathname.pwd.join('pkg')
          @package_dir = default_package_dir
          root = Pathname.new(__FILE__).parent.parent.parent.parent.parent
          @default_template_path = root.join('static', 'package-template-app.zip')
          @template_path = default_template_path
        end

        # @return [Pathname] default package directory: {pwd}/pkg/
        attr_reader :default_package_dir

        # @return [Pathname] package directory
        attr_accessor :package_dir

        # @return [Pathname] default path to .app template
        attr_reader :default_template_path

        # @return [Pathname] path to .app template
        attr_accessor :template_path

        attr_reader :config

        def package
          extract_template
        end

        def extract_template
          extracted_app = nil 
          Zip::ZipFile.new(template_path).each do |entry|
            extracted_app = template_path.join(entry.name) if Pathname.new(entry.name).extname == '.app'
            p = package_dir.join(entry.name)
            p.dirname.mkpath 
            entry.extract(p)
          end
          mv package_dir.join(extracted_app.basename), app_path
        end

        def app_path
          package_dir.join("#{config.name}.app")
        end
      end
    end
  end
end
