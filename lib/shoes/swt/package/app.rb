require 'pathname'
require 'zip/zip'

module Shoes
  module Package
    # Adapted from rubyzip's samples, ZipFileGenerator
    #
    # This is a simple example which uses rubyzip to recursively
    # generate a zip file containing the given entries and all of
    # their children.
    #
    # Best used throut frontend classes ZipDirectory or
    # ZipDirectoryContents
    #
    # @example
    # To zip the directory "/tmp/input" so that unarchiving
    # gives you a single directory "input":
    # 
    #   zip = RecursiveZip
    #   entries = Pathname.new("/tmp/input").entries
    #   zip_prefix = ''
    #   disk_prefix = '/tmp'
    #   output_file = '/tmp/out.zip'
    #   zf.write(entries, disk_prefix, zip_prefix, output_file)
    class RecursiveZip
      # Zip the contents of the input directory, without the root.
      def write_without_directory()
        entries = @input_dir.entries - ['.', '..']
        write entries, @input_dir, '' 
      end

      # @param [Array<Pathname>] entries the initial set of files to include
      # @param [Pathname] disk_prefix a path prefix for existing entries
      # @param [Pathname] zip_prefix a path prefix to add within archive
      # @param [Pathname] output_file the location of the output archive
      def write(entries, disk_prefix, zip_prefix, output_file)
        io = Zip::ZipFile.open(output_file.to_s, Zip::ZipFile::CREATE); 
        write_entries(entries, disk_prefix, zip_prefix, io)
        io.close();
      end

      # A helper method to make the recursion work.
      private
      def write_entries(entries, disk_prefix, path, io)
        entries.each do |e|
          zip_path = path.to_s == "" ? e.basename : path.join(e.basename)
          disk_path = disk_prefix.join(zip_path)
          puts "Deflating " + disk_path
          if disk_path.directory?
            io.mkdir(zip_path)
            subdir = disk_path.entries - ['.', '..']
            write_entries(subdir, zip_path, disk_prefix, io)
          else
            io.get_output_stream(zip_path) { |f| f.puts(File.open(disk_path, "rb").read())}
          end
        end
      end
    end        
  end
end
