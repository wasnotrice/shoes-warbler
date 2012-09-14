DEPS = FileList['vendor/*']

desc "Build and install custom dependencies"
task :deps do
  DEPS.each do |dep|
    cd dep do
      sh "gem build #{dep.pathmap('%f.gemspec')}"
    end
    gemfile = FileList["#{dep}/#{dep.pathmap('%f')}-*.gem"].first
    sh "gem install #{gemfile}"
    rm_f gemfile
  end
end
