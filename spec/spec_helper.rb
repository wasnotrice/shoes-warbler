require 'pathname'

module PackageHelpers
  # need these values from a context block, so let doesn't work
  def spec_dir
    Pathname.new(__FILE__).parent
  end

  def input_dir
    spec_dir.join 'support', 'zip'
  end
end

module ZipHelpers
  include PackageHelpers
  # dir = Pathname.new('spec/support/zip')
  # add_trailing_slash(dir) #=> '/path/to/spec/support/zip/'
  def add_trailing_slash(dir)
    dir.to_s + "/"
  end

  def relative_input_paths(from_dir)
    Pathname.glob(input_dir + "**/*").map do |p|
      directory = true if p.directory?
      relative_path = p.relative_path_from(from_dir).to_s
      relative_path = add_trailing_slash(relative_path) if directory
      relative_path
    end
  end
end

Pathname.glob(Pathname.new(__FILE__).parent.join('support/**/shared*.rb')).each do |f|
  require f.to_s
end

