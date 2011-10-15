task :build do
  system "coffee -o src/javascripts -c src/coffee"
  system "staticmatic build ."
  system "cp -vr src/javascripts site/"
end

task :server do
  system "staticmatic preview . &"
end

task :default => [:build]
