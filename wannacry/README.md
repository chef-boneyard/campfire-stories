# Windows WANNACRY demo

This demo utilizes `wannacry` for a detect/correct demo. 

Start at the Compliance tab, to show systems vulnerable. Drill into systems and failing controls to show what is failing and why it is failing.

To remeidate, add `recipe[tissues::default]` to the run_list in `roles/teardrop.json`. This change can be pushed through workflow or with the `./remediate.ps1` script.
