task :build do
  system "coffee -o src/javascripts -c src/coffee"
  system "staticmatic build ."
  system "cp -r src/javascripts site/javascripts"
end

task :server do
  system "staticmatic preview . &"
end

task :default => [:build]
