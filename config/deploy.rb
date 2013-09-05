require 'bundler/capistrano'
require 'capistrano-unicorn'

set :application, 'inseason'
set :repository,  'git@github.com:joeyschoblaska/inseason'
set :scm, :git
set :deploy_to, "/home/deploy/#{application}"
set :use_sudo, false

ssh_options[:forward_agent] = true

role :web, 'deploy@whatfoodsareinseason.com'
role :app, 'deploy@whatfoodsareinseason.com'

after 'deploy:restart', 'unicorn:reload'
