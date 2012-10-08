include ZipHelpers

shared_context 'package' do
  let(:output_dir) { spec_dir.join 'pkg' }
end

shared_context 'zip' do
  include_context 'package'
  let(:output_file) { output_dir.join 'zip_directory_spec.zip' }
  let(:zip) { Zip::ZipFile.open output_file }

  before :all do
    output_dir.mkpath
    subject.write
  end

  after :all do
    FileUtils.rm_rf output_dir
  end
end
