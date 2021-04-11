Import-Module PSMenu

$ImagesDirectoryPath = Join-Path $PSScriptRoot -ChildPath "..\images\blog"
$ImagesDirectories = Get-ChildItem -Path $ImagesDirectoryPath -Directory -Recurse | Sort-Object -Property LastWriteTime -Descending | Select-Object -ExpandProperty FullName

$DirToConvertPath = Show-Menu -MenuItems $ImagesDirectories

if (!$DirToConvertPath) {
    Write-Host "No directory chosen"
    Return
}

Write-Host "Enumerating files in $($DirToConvertPath)"
$ImageFiles = Get-ChildItem -Path $DirToConvertPath -Filter "*.heic"

. "$PSScriptRoot/ConvertTo-Jpeg.ps1"

$ImageFiles | Select-Object -ExpandProperty FullName | ConvertTo-Jpeg

