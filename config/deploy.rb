set :application, "coffecam"
set :repository,  "git://github.com/barnaba/coffeecam.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "nestene"                          # Your HTTP server, Apache/etc
set :branch, "master"
set :keep_releases, 3
ssh_options[:forward_agent] = true

set :deploy_to, "/var/www/coffecam"
default_run_options[:pty] = true


after 'deploy' do
  run "cd #{release_path} && rake"
end
