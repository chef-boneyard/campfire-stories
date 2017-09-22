#
# Cookbook:: build_cookbook
# Recipe:: publish
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'knife_role_from_file_teardrop' do 
    command "knife role from file roles/teardrop.json --config #{delivery_knife_rb}"
    cwd workflow_workspace_repo
end
