shared_context 'zip' do
  let(:output_dir) { spec_dir.join 'tmp' }
  let(:output_file) { output_dir.join 'zip_directory_spec.zip' }
  let (:zip) { Zip::ZipFile.open output_file }

  before :each do
    FileUtils.mkdir_p output_dir
    subject.write
  end

  after :each do
    FileUtils.rm_rf output_dir
  end
end
