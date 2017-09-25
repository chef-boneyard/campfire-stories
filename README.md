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

