module Shoes
  module Package
    class Configuration
      # @param [Hash] config user options
      def initialize(config={})
        @config = {
          name: 'Shoes App',
          ignore: [],
          gems: [],
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
        @config[:shortname] = @config[:name].downcase.gsub(/\W+/, '')

        # Overwrite defaults with supplied config
        @config = config.inject(@config) { |c, (k, v)| set c, k, v }

        # Define accessors for each key
        metaclass = class << self; self; end
        @config.keys.each do |k|
          metaclass.send(:define_method, k) do
            @config[k]
          end
          metaclass.send(:define_method, "#{k}=".to_sym) do |v|
            @config = set @config, k, v
          end
        end
      end

      private
      # Ensure symbol keys, even in nested hashes
      # 
      # @param [Hash] config the hash to set (key: value) on
      # @param [#to_sym] k the key
      # @param [Object] v the value
      # @return [Hash] an updated hash
      def set(config, k, v)
        if v.kind_of? Hash
          config[k.to_sym] = v.inject({}) { |hash, (k, v)| set(hash, k, v) }
        else
          config[k.to_sym] = v
        end
        config
      end
    end
  end
end
