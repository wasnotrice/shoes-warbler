require 'shoes/package/configuration'
require 'shoes/package/zip_directory'
require 'fileutils'
require 'plist'

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
          inject_icon
          inject_config
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
          executable_path.chmod 0755
        end

        def inject_config
          plist = app_path.join 'Contents/Info.plist'
          template = Plist.parse_xml(plist)
          template['CFBundleIdentifier'] = "com.hackety.shoes.#{config.shortname}"
          template['CFBundleDisplayName'] = config.name
          template['CFBundleName'] = config.name
          template['CFBundleVersion'] = config.version
          template['CFBundleIconFile'] = Pathname.new(config.icons[:osx]).basename.to_s
          File.open(plist, 'w') { |f| f.write template.to_plist }
        end

        def inject_icon
          resources_dir = app_path.join('Contents/Resources')
          rm_rf resources_dir.join('GenericApp.icns')
          icon_path = Pathname.new(config.icons[:osx])
          cp icon_path, resources_dir.join(icon_path.basename)
        end

        def app_path
          package_dir.join("#{config.name}.app")
        end
        
        def executable_path
          app_path.join('Contents', 'MacOS', 'JavaAppLauncher')
        end
      end
    end
  end
end
