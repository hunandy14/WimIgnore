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
    $onedrive.FullName | ForEach-Object {
        $path=$_ -replace ("$DriveLetter`:", "")
        $ignore = $ignore + "$path`n"
    }
    if (!$Out) { $Out = "$curDir\WimScript2.ini" }
    [System.IO.File]::WriteAllLines($Out, $ignore);
}
# WimIgnore C -Out:WimScript.ini
# WimIgnore C -Out:"Z:\WimScript.ini"
