include ZipHelpers

shared_context 'package' do
  let(:output_dir) { spec_dir.join 'tmp' }

  before :each do
    FileUtils.mkdir_p output_dir
  end

  after :each do
    FileUtils.rm_rf output_dir
  end
end

shared_context 'zip' do
  include_context 'package'
  let(:output_file) { output_dir.join 'zip_directory_spec.zip' }
  let(:zip) { Zip::ZipFile.open output_file }

  before :each do
    subject.write
  end
end
