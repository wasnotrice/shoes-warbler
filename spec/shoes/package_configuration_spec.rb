require 'spec_helper'
require 'shoes/package/configuration'

describe Shoes::Package::Configuration do
  context "defaults" do
    subject { Shoes::Package::Configuration.new }

    its(:name) { should eq('Shoes App') }
    its(:shortname) { should eq('shoesapp') }
    its(:ignore) { should be_empty }
    its(:gems) { should include('shoes') }
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

    describe "#to_hash" do
      it "round-trips" do
        Shoes::Package::Configuration.new(subject.to_hash).should eq(subject)
      end
    end
  end

  context "with options" do
    include_context 'config'
    let(:options) { YAML.load(File.read config_filename) }
    subject { Shoes::Package::Configuration.new options }

    its(:name) { should eq('Sugar Clouds') }
    its(:shortname) { should eq('sweet-nebulae') }
    its(:ignore) { should include('pkg') }
    its(:gems) { should include('rspec') }
    its(:gems) { should include('shoes') }
    its(:version) { should eq('0.0.1') }
    its(:release) { should eq('Mindfully') }
    its(:icons) { should be_an_instance_of(Hash) }
    its(:dmg) { should be_an_instance_of(Hash) }

    describe "#icon" do
      it 'has osx' do
        subject.icons[:osx].should eq('img/boots.icns')
      end

      it 'has gtk' do
        subject.icons[:gtk].should eq('img/boots_512x512x32.png')
      end

      it 'has win32' do
        subject.icons[:win32].should eq('img/boots.ico')
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

    it "incorporates custom features" do
      subject.custom.should eq('my custom feature')
    end
  end

  context "with name, but without explicit shortname" do
    let(:options) { {:name => "Sugar Clouds"} }
    subject { Shoes::Package::Configuration.new options }

    its(:name) { should eq("Sugar Clouds") }
    its(:shortname) { should eq("sugarclouds") }
  end

  context "auto-loading" do
    include_context 'config'

    context "without a path" do
      it "looks for 'app.yaml' in current directory" do
        Dir.chdir config_filename.parent do
          config = Shoes::Package::Configuration.load
          config.shortname.should eq('sweet-nebulae')
        end
      end

      it "blows up if it can't find the file" do
        Dir.chdir File.dirname(__FILE__) do
          lambda { config = Shoes::Package::Configuration.load }.should raise_error
        end
      end
    end

    context "with a path" do
      it "uses the path" do
        Dir.chdir File.dirname(__FILE__) do
          config = Shoes::Package::Configuration.load(config_filename)
          config.shortname.should eq('sweet-nebulae')
        end
      end
    end
  end
end
