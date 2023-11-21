<#
	Module powershellmarks

    Powershellmarks is a powershell module that allows you to save and jump to commonly
    used directories. Supports tab completion.

    The bookmarks file is stored in the user's home folder (~/.sdirs).
    It is simply a text file, meaning it may be edited by the user.

    USAGE:
    s bookmarkname - saves the curr dir as bookmarkname
    g bookmarkname - jumps to the that bookmark
    g b[TAB] - tab completion is available
    p bookmarkname - prints the bookmark
    p b[TAB] - tab completion is available
    d bookmarkname - deletes the bookmark
    d [TAB] - tab completion is available
    l - list all bookmarks

	Version history
	---------------
	v1.0.0	- Initial version

	GNU GENERAL PUBLIC LICENSE Version 2
	https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
#>

$SDIRS = "~/.sdirs"
if (!(Test-Path -Path $SDIRS)) {
    New-Item -Path $SDIRS -ItemType File -Force
}

function Get-Bookmark {
    param(
        [string]$name
    )
    return Get-Content -Path $SDIRS | Where-Object { $_ -match "$name=" } | ForEach-Object { $_ -replace "$name=|`"", "" }
}

function Add-Bookmark {
    param(
        [string]$name
    )
    if ([string]::IsNullOrEmpty($name)) {
        Write-Error "Bookmark name is required"
    }
    elseif ($name -ne ($name -creplace '[^\w]')) {
        Write-Error "The bookmark name is not valid"
    }
    $target = Get-Bookmark $name
    if (!$target) {
        "$name=`"$(Convert-Path -LiteralPath $PWD)`"" | Out-File -FilePath $SDIRS -Append
    }
}

function Remove-Bookmark {
    param(
        [string]$name
    )
    $tempFile = "~/.sdirs.bak"
    Move-Item -Path $SDIRS -Destination $tempFile -Force
    Get-Content -Path $tempFile | Where-Object { $_ -notmatch "$name=" } | Set-Content -Path $SDIRS
    if (!(Test-Path -Path $SDIRS)) {
        New-Item -Path $SDIRS -ItemType File -Force
    }
    Remove-Item -Path $tempFile
}

function Open-Bookmark {
    param(
        [string]$name
    )
    $target = Get-Bookmark $name
    if (Test-Path -Path $target) {
        Set-Location -Path $target
    }
    else {
        Write-Error "'$name' bookmark does not exist"
    }
}

function Show-Bookmark {
    param(
        [string]$name
    )
    $target = Get-Bookmark $name
    Write-Host $target -ForegroundColor "Yellow"
}

function Show-Bookmarks {
    Get-Content -Path $SDIRS | ForEach-Object {
        $parts = $_ -split "="
        Write-Host "$($parts[0]) $($parts[1])" -ForegroundColor "Yellow"
    }
}

$completionBlock = {
    param(
        $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters
    )
    Get-Content -Path $SDIRS | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object { $($_ -split "=")[0] }
}
Register-ArgumentCompleter -CommandName Open-Bookmark -ParameterName name -ScriptBlock $completionBlock

New-Alias -Name s -Value Add-Bookmark
New-Alias -Name d -Value Remove-Bookmark
New-Alias -Name g -Value Open-Bookmark
New-Alias -Name p -Value Show-Bookmark
New-Alias -Name l -Value Show-Bookmarks