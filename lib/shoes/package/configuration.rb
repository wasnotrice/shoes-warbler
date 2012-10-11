require 'pathname'

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
      # @param [String] file the filename to load
      def self.load(filename = 'app.yaml')
        file = Pathname.new(filename)
        raise IOError, "Couldn't find #{file} at #{file.expand_path}" unless File.exist?(file)
        new YAML.load(file.open), file.dirname
      end

      # @param [Hash] config user options
      def initialize(config = {}, working_dir = Dir.pwd)
        defaults = {
          name: 'Shoes App',
          version: '0.0.0',
          release: 'Rookie',
          icons: {
            osx: 'path/to/default/App.icns',
            gtk: 'path/to/default/app.png',
            win32: 'path/to/default/App.ico',
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
