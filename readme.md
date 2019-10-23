pdbuild
=======

pdbuild is my personal powershell pandoc build script. I wrote it as an experiment to see if I could ditch word processors for document presentation and it has so far been a success.

## Requirements ##

pdbuild depends on sass, pandoc, and wkhtmltopdf.exe. They will need to be accessible from your PATH in order for these scripts to work.

## Installation ##

Extract or clone this repository somewhere on your system and add it to your PATH.

## Usage ##

To create a new document, create a new folder and run pdinit on it. Optional parameters are:

```powershell
[string] $Title,
[string] $Subtitle,
[string[]] $Authors = {"your default Windows full name"},
[DateTime] $CreationDate = $(Get-Date)
```

This will populate the new folder with the files necessary for pdbuild.

Once your document is ready to be built, run pdbuild on the target markdown file and a pdf will be generated for it. Optional parameters are:

```powershell
[string] $OutPath = ".\out.pdf"
[string] $Template = ""
[switch] $TableOfContents = $false
[string] $HighlightStyle = "breezeDark"
```

## Configuration ##

pdinit copies files from the .pdinit folder when it runs. pdinit and pdbuild expect them to be there, even if they're blank, so don't delete them. These are where your default style and layout go. Supplied is a simple style based loosely on Google's Material Design.