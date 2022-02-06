function Start-Jekyll() {
	$Cmd = "wsl"
	$CmdArgs = @("./build.sh")
	
	Write-Host "$Cmd $CmdArgs"
    & $Cmd $CmdArgs
}

if (!(Get-Command wsl -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor Red -Object "wsl not installed"
    Exit -1
}

## Start
Write-Host "sebazzz.github.io build menu"
Write-Host "1. Build & serve"
Write-Host "2. Rebuild & serve"
$choice = Read-Host -Prompt "Enter choice: "

switch ([int]$choice) {
    1 { 
        Start-Jekyll
    }
    2 { 
        Remove-Item -Path "_site" -Recurse -ErrorAction Continue
        Start-Jekyll
    }
}