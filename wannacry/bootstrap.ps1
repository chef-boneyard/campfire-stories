Param([string]$password = "workstation-1", [string]$environment="_default")

Write-Host -ForegroundColor green "Installing knife-ec2 gem"
chef gem install knife-ec2

Write-Host -ForegroundColor green "Seeding Chef Server with roles and cookbooks"
berks install 
berks upload
knife role from file roles/teardrop.json

Write-Host -ForegroundColor green "Generating user-data script"
$chef_ip = [System.Net.Dns]::GetHostAddresses("chef.automate-demo.com")

$userdataTemplate = Get-Content -Raw ".\user-data.dtsx"
$userdataTemplate = $userdataTemplate.Replace("[CHEF_IP]", $chef_ip)
$userdataTemplate = $userdataTemplate.Replace("[CHEF_PASSWORD]", "$password")
Set-Content -Encoding utf8 "./user-data" $userdataTemplate

Write-Host -ForegroundColor green "Creating Windows Instance"
knife ec2 server create `
  --image ami-89c18fb9 `
  --flavor m4.large `
  --ssh-key chef_demo_2x `
  --winrm-transport text `
  --config ./knife.rb `
  --user-data ./user-data `
  --winrm-user '.\chef' `
  --winrm-password "$password" `
  --associate-public-ip `
  --run-list "role[teardrop]" `
  --environment "$environment" `
  --tags "created-by=test-kitchen,demo-type=bjc-campfire"
