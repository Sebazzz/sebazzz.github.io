function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function Start-Jekyll() {
	$cmd = "jekyll"
	$args = @("serve", "--drafts", "--future")
	
	$cmdLine = $cmd + " " + [String]::Join(" ", $args)
	Write-Host $cmdLine

    $process = Start-Process -PassThru -FilePath $cmd -ArgumentList $args -WindowStyle Minimized
    Return $process
}

if ((Check-Command jekyll) -eq $false) {
    Write-Host -ForegroundColor Red -Object "Jekyll not found in path"
    Exit -1
}

## Start
Write-Host "sebazzz.github.io build menu"
Write-Host "1. Build & serve"
Write-Host "2. Rebuild & serve"
$choice = Read-Host -Prompt "Enter choice: "

switch ([int]$choice) {
    1 { 
        $process = Start-Jekyll
    }
    2 { 
        Remove-Item -Path "_site" -Recurse -ErrorAction Continue
        $process = Start-Jekyll
    }
}

if ($process -ne $null) {
	Write-Host "Launching web browser"
    Start-Sleep -Seconds 5

    if ($process.Exited) {
		Write-Error "Error launching jekyll..."
		Read-Host
		Exit -1
	}

    Start-Process -FilePath "http://localhost:4000"

    Read-Host -Prompt "Press any key to terminate"
    [void]$process.CloseMainWindow()
    [void]$process.WaitForExit(500)

    if ($process.Exited -eq $false) {
        [void]$process.Kill()
    }
}
