task :build do
  system "coffee -o src/javascripts -c src/coffee"
  system "staticmatic build ."
  system "cp -vr src/javascripts site/"
end

task :server do
  system "staticmatic preview . &"
  system "coffee -o site/javascripts -w -c src/coffee"
end

task :default => [:build]
