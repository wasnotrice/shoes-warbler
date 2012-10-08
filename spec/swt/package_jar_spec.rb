require 'spec_helper'
require 'pathname'
require 'shoes/swt/package/jar'

include PackageHelpers

describe Shoes::Swt::Package::Jar do
  include_context 'config'
  include_context 'package'

  context "when creating a .jar" do
    before :all do
      output_dir.rmtree if output_dir.exist?
      output_dir.mkpath
      Dir.chdir spec_dir.join('support') do
        subject.package(output_file)
      end
    end

    let(:jar_name) { 'sweet-nebulae.jar' }
    let(:output_file) { Pathname.new(output_dir.join jar_name) }

    it "creates a .jar" do
      output_file.should exist
    end
  end
end