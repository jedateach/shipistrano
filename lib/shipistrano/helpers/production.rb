#
# DNA Shipistrano
#
# = Production 
#
# Contains helpers for managing a deploy that has a 'production' folder on top 
# of the current folder. For smaller setups, we use this over a dual stream 
# Capistrano setup (prod / stage environments with separate releases).
#
# == Variables
#
# == Tasks
#
# - *publish:code* copies the latest release to a `production_folder`
#
# == Todo
#
# - Tests
# - Document behaviour with shared assets, backup live assets vs staging

set :production_folder, fetch(:production_folder, "#{deploy_to}/production")

namespace :publish do

  desc <<-DESC
    Copies the current deployed version to a production folder. A backup of the 
    current site is saved to backup

  DESC
  task :code do
    run "if [ -d #{deploy_to}/backup ]; then rm -rf #{deploy_to}/backup; fi"
    run "if [ -d #{production_folder} ]; then mv #{production_folder} #{deploy_to}/backup; fi"
    run "cp -R #{latest_release} #{production_folder}"
    
    deploy.cleanup
  end
end