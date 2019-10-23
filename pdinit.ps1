Param (
    [Parameter(Mandatory)]
    [ValidateScript({
        if (-Not ($_ | Test-Path))
        {
            throw "The specified path does not exist."
        }

        if (-Not ($_ | Test-Path -PathType Container))
        {
            throw "The Path parameter must be a valid folder."
        }

        return $true
    })]
    [System.IO.FileInfo] $Path,
    [string] $Title,
    [string] $Subtitle,
    [string[]] $Authors = ([adsi]"WinNT://$env:userdomain/$env:username").fullname,
    [DateTime] $CreationDate = $(Get-Date)
)
[string]$AuthorStr = ""
foreach ($a in $Authors)
{
    $authorStr += "`n  - `"$a`""
}

Copy-Item -Force -Path "$PSScriptRoot\.pdinit\main.scss" -Destination $Path
Copy-Item -Force -Path "$PSScriptRoot\.pdinit\before.html" -Destination $Path
Copy-Item -Force -Path "$PSScriptRoot\.pdinit\after.html" -Destination $Path
Copy-Item -Force -Path "$PSScriptRoot\.pdinit\header.html" -Destination $Path

Set-Content -Path "$Path\document.md" -Value @"
---
$(If (![string]::IsNullOrWhiteSpace($Title)) {"title: `"$Title`""} Else {$null})
$(If (![string]::IsNullOrWhiteSpace($Subtitle)) {"subtitle: `"$Subtitle`""} Else {$null})
$(If (![string]::IsNullOrWhiteSpace($AuthorStr)) {"author: $AuthorStr"} Else {$null})
date: `"$CreationDate`"
---

"@