Param([string]$password)

if(!$password) {
  Write-Host "You must specify the same password you provided to bootstrap. Ex: ./remediate.ps1 my-super-secret-password"
  exit
}

knife winrm -a ipaddress -x chef -P "$password" "roles:teardrop" "chef-client"
