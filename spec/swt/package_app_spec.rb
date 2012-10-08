require 'spec_helper'
require 'pathname'
require 'shoes/swt/package/app'

include PackageHelpers

describe Shoes::Swt::Package::App do
  include_context 'config'
  include_context 'package'

  let(:output_file) { Pathname.new(output_dir.join "Sugar Clouds.app") }
  let(:config) { Shoes::Package::Configuration.new options }
  subject { Shoes::Swt::Package::App.new config, Pathname.new('some/path') } 

  it "creates a .app" do
    subject.package(output_file)
    output_file.should exist
  end
end
