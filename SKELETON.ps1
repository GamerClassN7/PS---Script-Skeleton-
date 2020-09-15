
<#

Use: Skeleton template for PS Scripts

Author: Václav Španinger, Ondřej Kračmar

Create: 2020-09-15

Modification: 2020-09-15

#>

 

#Loding Config File

$configFile = "$(Get-Location)\config.json"

if (Test-Path -Path $configFile)  {

    $config = Get-Content -Path $configFile | ConvertFrom-Json

} else {

    Write-Host "Config Not Found !!!"

    exit

}

 

#Module Check

foreach ($module in $config.requiredModules) {

    if (-not (Get-Module -ListAvailable -Name  $module)) {

        Install-Module -Name $module -AllowClobber

    }

    Import-Module -Name $module  

}

 

#Folders Check

foreach ($folder in $config.requiredFolders) {

    if (-Not (Test-Path -Path "$(Get-Location)\$folder")) {

        New-Item -ItemType "directory" -Path "$(Get-Location)\$folder" > $null

    }   

}

 

#Setup

$scriptName = $($MyInvocation.MyCommand.Name).Split(".")[0];

$scriptPath = "$PSScriptRoot\$scriptName";

$startLocation = (Get-Location);

$startFolderName = ($startLocation -split "\\")[-1]

 

if ($scriptName -ne $startFolderName) {

    if (-Not (Test-Path -Path "$PSScriptRoot\$scriptName")) {

        New-Item -Path "$PSScriptRoot\" -Name $scriptName -ItemType "directory" > $null

    }

    else {

        Remove-Item -Path $scriptPath -Recurse -Force

    }

    Copy-Item "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" "$PSScriptRoot\$scriptName\$($MyInvocation.MyCommand.Name)"

    Remove-Item -Path "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Force

    Set-Location -Path "$PSScriptRoot\$scriptName"

}

else {

    Set-Location -Path $PSScriptRoot

}

 
#MainFunction