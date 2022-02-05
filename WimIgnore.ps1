# 建立 WimIgnore.ini 檔案
function WimIgnore {
    param (
        [Parameter(Position = 0, ParameterSetName = "", Mandatory=$true)]
        [string] $DriveLetter,
        [string] $Out
    )
    if ($PSScriptRoot) { $curDir = $PSScriptRoot } else { $curDir = (Get-Location).Path }
    $ignore = Invoke-RestMethod bit.ly/3qXkbkE
    $onedrive = (Get-ChildItem "$($DriveLetter):\Users" -Dir | ForEach-Object {
        Get-ChildItem $_.FullName -Dir -Filter:"Onedrive*"
    })
    Write-Host "WimIgnore will ignore the following paths"  -ForegroundColor:Yellow
    $onedrive.FullName | ForEach-Object {
        Write-Host "  - $_"
        $path=$_ -replace ("$DriveLetter`:", "")
        $ignore = $ignore + "$path`n"
    }
    if (!$Out) { $Out = "$curDir\WimScript.ini" }
    [System.IO.File]::WriteAllText($Out, $ignore.trim("`n"));
} # WimIgnore -DriveLetter:C -Out:"Z:\WimScript.ini"