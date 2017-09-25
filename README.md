# Prerequisites

* Scripts are executed from a Windows workstation in a BJC demo environment
* Demo environment is in us-west-2


# Usage

There are two methods for utilizing these scripts.  Standalone, which creates a single instance and allows you to remediate with `knife ssh/winrm` or `chef-client` on a short interval.  Or Workflow, which will create AURD instances and initiate a workflow pipeline for you to push changes through. Pipeline also requires you to have push jobs or chef-client on a short interval in your run list. 

## Standalone

On the BJC Windows workstation:
1. `git clone https://github.com/chef-cft/campfire-stories`
2. `cd` into the direcory for the demo you wish to use
3. `./bootstrap.ps1`
  * Windows requires an additional `-password SUPER_SECRET` for winrm
4. Check Nodes/Compliance after the instance has been created
5. DEMOTIME
  * In `wannacry` there is a `remediate.ps1` script with the correct invocation of `knife winrm` to force your nodes to check in. 

## Workflow

On the BJC Windows workstation:
1. `git clone https://github.com/chef-cft/campfire-stories`
2. `./storytime.ps1 DEMO_NAME` 
  * ex: `./storytime.ps1 wannacry`
  * Windows requires an extra parameter for the winrm password: `./storytime.ps1 wannacry -password SUPER_SECRET`
3. Check Nodes/Compliance after the instance are created
4. DEMOTIME
  * Remediate by publishing changes through workflow with `delivery review` 

# Contributing

If you wish to add an additional demo story, first create the directory it will live under.  This can be done with `chef generate cookbook DEMO_NAME`.  You will need to remove the `.delivery` directory, unless you plan to customize the build cookbook.  See `wannacry` for an example.  *NOTE* It is very important that you set the `job_dispatch` version to `v1` in `config.json`.  BJC utilizes build nodes exclusivly and `v2` jobs will appear to hang indefinately. 

Next, you will need to copy `bootstrap.ps1`, `userdata.dtx`, and `knife.rb` from either the windows or linux example,  whichever is appropriate for your demo. Then you will need to edit the cookbook to set the initial state of your demo.  Finally,  create a readme describing the talk track and any remediation steps necessary.  

## Custom build cookbook

`./storytime.ps1` will copy a default `.delivery` directory, including the build cookbook, if it doesn't find a `.delivery` directory present. You should only need to provide a custom build cookbook if you need different behavior than what delivery-truck provides. 
