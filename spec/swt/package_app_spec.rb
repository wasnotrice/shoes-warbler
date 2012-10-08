require 'spec_helper'
require 'pathname'
require 'shoes/swt/package/app'

include PackageHelpers

describe Shoes::Swt::Package::App do
  include_context 'config'
  include_context 'package'

  let(:app_name) { 'Sugar Clouds.app' }
  let(:output_file) { Pathname.new(output_dir.join app_name) }
  let(:config) { Shoes::Package::Configuration.new options }
  subject { Shoes::Swt::Package::App.new config } 

  context "default" do
    it "package dir is {pwd}/pkg" do
      Dir.chdir spec_dir do
        subject.default_package_dir.should eq(spec_dir.join('pkg'))
      end
    end

    its(:template_path) { should eq(spec_dir.parent.join('static', 'package-template-app.zip')) }
    its(:template_path) { should exist }
  end

  context "when creating a .app" do
    before :all do
      output_dir.mkpath
      Dir.chdir spec_dir do
        subject.package
      end
    end

    after :all do
      #FileUtils.rm_rf output_dir
    end

    it "creates a .app" do
      output_file.should exist
    end

    it "includes application launcher" do
      output_file.join('Contents', 'MacOS', 'JavaAppLauncher').should exist
    end
  end
end
