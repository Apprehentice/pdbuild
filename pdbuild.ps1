Param (
    [System.IO.FileInfo] $Path,
    [ValidateScript({
        if (-Not ($_ | Test-Path))
        {
            throw "The specified path does not exist."
        }

        if (-Not ($_ | Test-Path -PathType Leaf))
        {
            throw "The Path parameter must be a valid file."
        }

        return $true
    })]
    [System.IO.FileInfo] $Scss = (New-Object -TypeName System.IO.FileInfo -ArgumentList "$PSScriptRoot\.pdinit\main.scss"),
    [string] $OutPath = ".\out.pdf",
    [string] $Template = "",
    [switch] $TableOfContents = $false,
    [string] $HighlightStyle = "breezeDark"
)

if (-Not $Path)
{
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
    $dialog.InitialDirectory = $HOME
    $dialog.Filter = "Markdown files (*.md)|*.md|All files (*.*)|*.*"
    $dialog.RestoreDirectory = $true

    if ($dialog.ShowDialog() -eq "OK")
    {
        $Path = $dialog.FileName
    }

    Push-Location $Path.Directory
}

Write-Debug "Input file: $Path"
Write-Debug "Output file: $OutPath"
Write-Debug "SCSS path: $Scss"

$PandocParams = @()
if ($TableOfContents)
{
    $PandocParams = $PandocParams += "--toc"
}

sass $Scss ".\$($Scss.Name).css"
pandoc $Path --self-contained @PandocParams --highlight-style $HighlightStyle --css ".\$($Scss.Name).css" --include-in-header ".\header.html" --include-before-body ".\before.html" --include-after-body ".\after.html" -o $OutPath --pdf-engine E:\Programs\wkhtmltopdf\bin\wkhtmltopdf.exe

Pop-Location