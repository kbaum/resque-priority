begin
  require "jeweler"

  Jeweler::Tasks.new do |gem|
    gem.name = "resque-priority"
    gem.version = "0.1"
    gem.summary = "Resque plugin that provides priority levels"
    gem.description = <<-desc
      Provides Resque with three levels of (named) priority for a single queue.
    desc
    gem.email = "brett@intraspirit.net"
    gem.homepage = "http://github.com/brettbuddin/resque-priority"
    gem.date = Time.now.strftime('%Y-%m-%d')
    gem.authors = ["Brett Buddin"]
    gem.files = %w( README.md Rakefile LICENSE )
    gem.files += Dir["*", "{lib}/**/*"]

    gem.has_rdoc = false
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
