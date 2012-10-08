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
      Dir.chdir app_dir do
        @jar_path = subject.package(output_dir)
      end
    end

    let(:jar_name) { 'sweet-nebulae.jar' }
    let(:output_file) { Pathname.new(output_dir.join jar_name) }

    it "creates a .jar" do
      output_file.should exist
    end

    it "returns path to .jar" do
      @jar_path.should eq(output_file.to_s)
    end

    its(:default_dir) { should eq('pkg') }
    its(:filename) { should eq(jar_name) }
  end
end
