require 'pathname'
require 'yaml'

module Shoes
  module Package
    # Configuration for Shoes packagers. Example usage:
    #
    #     custom_config = YAML.load(File.open('app.yaml'))
    #     config = Shoes::Package::Configuration(custom_config)
    #
    # If your configuration uses hashes, the keys will always be
    # symbols, even if you have created it with string keys. It's just
    # easier that way.
    #
    # This is a value object. If you need to modify your configuration
    # after initialization, dump it with #to_hash, make your changes,
    # and instantiate a new object.
    class Configuration
      # Convenience method for loading config from a file.
      #
      # @overload load(path)
      #   @param [String] path location of the app's 'app.yaml'
      # @overload load(path)
      #   @param [String] path location of the directory that
      #      contains the app's 'app.yaml'
      # @overload load(path)
      #   @param [String] path location of the app
      def self.load(path = 'app.yaml')
        pathname = Pathname.new(path)
        app_yaml = Pathname.new('app.yaml')

        dummy_file = Struct.new(:open, :exist?, :expand_path, :basename)

        if pathname.basename == app_yaml
          file, dir = pathname, pathname.dirname
        elsif pathname.directory?
          file, dir = pathname.join(app_yaml), pathname
        elsif pathname.file? && pathname.parent.children.include?(pathname.parent.join app_yaml)
          file, dir = pathname.parent.join(app_yaml), pathname.parent
        else
          # Can't find any 'app.yaml', so assume we just want to wrap
          # this file. Delegate existential qualities to the original
          # pathname
          options = {run: pathname.to_s}.to_yaml
          file = dummy_file.new(options, pathname.file?, pathname.expand_path, pathname.basename)
          dir = pathname.parent
        end
        new YAML.load(file.open), dir 
      end

      # @param [Hash] config user options
      def initialize(config = {}, working_dir = Dir.pwd)
        defaults = {
          name: 'Shoes App',
          version: '0.0.0',
          release: 'Rookie',
          run: nil,
          ignore: 'pkg',
          icons: {
            #osx: 'path/to/default/App.icns',
            #gtk: 'path/to/default/app.png',
            #win32: 'path/to/default/App.ico',
          },
          dmg: {
            ds_store: 'path/to/default/.DS_Store',
            background: 'path/to/default/background.png'
          }
        }

        # Overwrite defaults with supplied config
        @config = config.inject(defaults) { |c, (k, v)| set_symbol_key c, k, v }

        # Ensure that we always have what we need
        @config[:shortname] ||= @config[:name].downcase.gsub(/\W+/, '')
        [:ignore, :gems].each { |k| @config[k] = Array(@config[k]) }
        @config[:gems] << 'shoes'

        # Define reader for each key
        metaclass = class << self; self; end
        @config.keys.each do |k|
          metaclass.send(:define_method, k) do
            @config[k]
          end
        end

        @working_dir = Pathname.new(working_dir)
      end

      # @return [Pathname] the current working directory
      attr_reader :working_dir

      def to_hash
        @config
      end

      def ==(other)
        super unless other.respond_to?(:to_hash)
        @config == other.to_hash
      end

      private
      # Ensure symbol keys, even in nested hashes
      #
      # @param [Hash] config the hash to set (key: value) on
      # @param [#to_sym] k the key
      # @param [Object] v the value
      # @return [Hash] an updated hash
      def set_symbol_key(config, k, v)
        if v.kind_of? Hash
          config[k.to_sym] = v.inject({}) { |hash, (k, v)| set_symbol_key(hash, k, v) }
        else
          config[k.to_sym] = v
        end
        config
      end
    end
  end
end
