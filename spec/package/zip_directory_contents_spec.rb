require 'spec_helper'
require 'support/shared_zip'
require 'fileutils'
require 'shoes/package/zip_directory_contents'

include ZipHelpers

describe Shoes::Package::ZipDirectoryContents do
  include_context 'zip'

  context "output file" do
    it "exists" do
      output_file.should exist
    end

    it "does not include input directory without parents" do
      zip.entries.map(&:name).should_not include(add_trailing_slash input_dir.basename)
    end

    relative_input_paths(input_dir).each do |path|
      it "includes all children of input directory" do
        zip.entries.map(&:name).should include(path)
      end
    end
  end
end
