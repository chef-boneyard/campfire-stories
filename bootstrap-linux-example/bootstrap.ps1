Param([string]$password)
Param([string]$environment="_default")

if (!$password) {
  Write-Host "You must specify a password. Ex: ./bootstrap.ps1 my-super-secret-password"
  exit
}

Write-Host -ForegroundColor green "Installing knife-ec2 gem"
chef gem install knife-ec2

Write-Host -ForegroundColor green "Seeding Chef Server with roles and cookbooks"

Write-Host -ForegroundColor green "Generating user-data script"
$chef_ip = [System.Net.Dns]::GetHostAddresses("chef.automate-demo.com")[0]
$automate_ip = [System.Net.Dns]::GetHostAddresses("automate.automate-demo.com")[0]

$userdataTemplate = Get-Content -Raw ".\user-data.dtsx"
$userdataTemplate = $userdataTemplate.Replace("[CHEF_IP]", $chef_ip)
$userdataTemplate = $userdataTemplate.Replace("[AUTOMATE_IP]", "$automate_ip")
Set-Content -Encoding ASCII "./user-data" $userdataTemplate
chmod +x "./user-data"


Write-Host -ForegroundColor green "Creating $environment instance"
knife ec2 server create `
  --image ami-8803e0f0 `
  --flavor t2.micro `
  --ssh-user ubuntu `
  --ssh-key chef_demo_2x `
  --config ./knife.rb `
  --user-data ./user-data `
  --associate-public-ip `
  --run-list "[[RECIPE]]" `
  --environment $environment
