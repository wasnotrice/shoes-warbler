require 'shoes/package/configuration'
require 'yaml'

describe Shoes::Package::Configuration do
  context "defaults" do
    subject { Shoes::Package::Configuration.new }

    its(:name) { should eq('Shoes App') }
    its(:shortname) { should eq('shoesapp') }
    its(:ignore) { should be_empty }
    its(:gems) { should be_empty }
    its(:version) { should eq('0.0.0') }
    its(:release) { should eq('Rookie') }
    its(:icons) { should be_an_instance_of(Hash) }
    its(:dmg) { should be_an_instance_of(Hash) }
    
    describe "#icon" do
      it 'has osx' do
        subject.icons[:osx].should eq('path/to/default/App.icns')
      end

      it 'has gtk' do
        subject.icons[:gtk].should eq('path/to/default/app.png')
      end

      it 'has win32' do
        subject.icons[:win32].should eq('path/to/default/App.ico')
      end
    end

    describe "#dmg" do
      it "has ds_store" do
        subject.dmg[:ds_store].should eq('path/to/default/.DS_Store')
      end

      it "has background" do
        subject.dmg[:background].should eq('path/to/default/background.png')
      end
    end
  end

  context "with options" do
    let(:config_filename) { File.expand_path '../../support/app.yaml', __FILE__ }
    let(:options) { YAML.load(File.read config_filename) }
    subject { Shoes::Package::Configuration.new options }

    its(:name) { should eq('Sugar Clouds') }
    its(:shortname) { should eq('sweet-nebulae') }
    its(:ignore) { should include('vendor') }
    its(:gems) { should include('rspec') }
    its(:version) { should eq('0.0.1') }
    its(:release) { should eq('Mindfully') }
    its(:icons) { should be_an_instance_of(Hash) }
    its(:dmg) { should be_an_instance_of(Hash) }
    
    describe "#icon" do
      it 'has osx' do
        subject.icons[:osx].should eq('path/to/custom/App.icns')
      end

      it 'has gtk' do
        subject.icons[:gtk].should eq('path/to/custom/app.png')
      end

      it 'has win32' do
        subject.icons[:win32].should eq('path/to/custom/App.ico')
      end
    end

    describe "#dmg" do
      it "has ds_store" do
        subject.dmg[:ds_store].should eq('path/to/custom/.DS_Store')
      end

      it "has background" do
        subject.dmg[:background].should eq('path/to/custom/background.png')
      end
    end
  end
end