$PSScriptRoot | Set-Location
Set-Location ..

$Posts = Get-ChildItem -Path "_posts" -Recurse -Filter *.md -Name | Split-Path -LeafBase

# Find all images with this prefix, make a directory, and move them into it
foreach ($Prefix in $Posts) {
    Write-Host "Checking [$Prefix]"
    [array] $Images = Get-ChildItem -Path "images/blog" -File -Filter "$($Prefix)*"
    
    if ($Images.Count -eq 0) {
        Write-Host "... found nothing"
        continue
    }

    Write-Host "... found $($Images.Count) images"

    $TargetDirRelativePath = "images/blog/$($Prefix)"
    if (Test-Path -Path $TargetDirRelativePath) {
        Write-Warning "`tDirectory already exists: $TargetDirRelativePath"
        $NewDirectoryPath = Resolve-Path $TargetDirRelativePath
    } else {
        $NewDirectoryPath = New-Item -Path $TargetDirRelativePath -Type Directory -Verbose | Select-Object -ExpandProperty FullName
    }
    Write-Host "`tCreated directory [$($NewDirectoryPath)]"

    foreach ($Image in $Images) {
        Write-Host "`tHandling $($Image.Name)"
        $NewImagePath = Join-Path $NewDirectoryPath $Image.Name.Replace("$($Prefix)-", "").Replace($Prefix, "primary")
        $NewImageName = Split-Path -Path $NewImagePath -Leaf

        & "git" @("mv", $Image.FullName, $NewImagePath)
        Write-Host "`t... Moved [$($Image.FullName)] to [$($NewImagePath)]"


        # Replace in all posts .md file
        foreach ($PostFilePrefix in $Posts) {
            $PostFilePath = Join-Path "_posts" "$($PostFilePrefix).md"
            $PostContent = Get-Content $PostFilePath -Raw -Encoding utf8NoBOM
            $OriginalPostContent = $PostContent
            $PostContent = $PostContent -ireplace "images/blog/$($Image.Name)","images/blog/$Prefix/$NewImageName"
            
            if ($OriginalPostContent -ne $PostContent) {
                Set-Content $PostFilePath $PostContent -Encoding utf8NoBOM
                & "git" @("add", $PostFilePath)
            }
        }
    }
}

