Param(
    [string]$story
)

if( !$story -Or -Not(Test-Path $story)) {
    Write-Host -ForegroundColor Red "You must specify a demo you wish to run"
}

$target="$HOME/cookbooks/$story"

if( Test-Path $target ) {
    Write-Host -ForegroundColor Red "It looks like $story has already been initialized"
    Write-Host -ForegroundColor Red "  Remove $target to start over."
}

Write-Host -ForegroundColor Green "Copying $story to cookbooks"
Copy-Item $story $target -Recurse

Write-Host -ForegroundColor Green "Initializing build cookbook"

# Seed the delivery cookbook if there isn't a custom one.
if( -Not(Test-Path $target/.delivery)) {
    Copy-Item build-cookbook-template $target/.delivery -Recurse
}
# Prep the infrastructure
Push-Location $target

Write-Host "Prepping the infrastructure.  This may take a while"
berks install
berks upload --force

$environments = @("acceptance-automate-demo-automate-$story-master","union","rehearsal","delivered")

ForEach($environment in $environments) {
  Start-Job -Name "EC2Create-$environment" -ScriptBlock {
    param($environment, $workingDir)
    Set-Location $workingDir
    Write-Host -ForegroundColor green "Creating $environment"
    knife environment create -d $environment
    Write-Host -ForegroundColor green "Creating $environment instance"
    .\bootstrap.ps1 -environment $environment
  } -ArgumentList $environment, $target
}

git init
git add .
git commit -m "Initial commit"

Write-Host -ForegroundColor Blue "If it prompts for a password, use the same one you use to log into automate."
delivery init 
git checkout master
