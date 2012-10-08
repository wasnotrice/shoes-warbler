require 'yaml'

shared_context 'config' do
  let(:config_filename) { File.expand_path '../../support/app.yaml', __FILE__ }
  let(:options) { YAML.load(File.read config_filename) }
end