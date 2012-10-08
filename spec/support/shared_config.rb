require 'yaml'
require 'pathname'

shared_context 'config' do
  let(:config_filename) { Pathname.new(__FILE__).join('../../test_app/app.yaml').cleanpath }
  let(:options) { YAML.load(File.read config_filename) }
end
