$thisScriptFolder = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$chocInstallVariableName = "ChocolateyInstall"
$sysDrive = $env:SystemDrive
#$defaultNugetPath = "$sysDrive\Chocolatey"
$defaultChocolateyPathOld = "$sysDrive\NuGet"

function Set-ChocolateyInstallFolder($folder){
  #if(test-path $folder){
    write-host "Creating $chocInstallVariableName as a User Environment variable and setting it to `'$folder`'"
    [Environment]::SetEnvironmentVariable($chocInstallVariableName, $folder, [System.EnvironmentVariableTarget]::User)
    Set-Content "env:\$chocInstallVariableName" -value $folder -force
  #}
  #else{
  #  throw "Cannot set the chocolatey install folder. Folder not found [$folder]"
  #}
}

function Get-ChocolateyInstallFolder(){
  [Environment]::GetEnvironmentVariable($chocInstallVariableName, [System.EnvironmentVariableTarget]::User)
}

function Create-DirectoryIfNotExists($folderName){
  if (![System.IO.Directory]::Exists($folderName)) {[System.IO.Directory]::CreateDirectory($folderName)}
}

function Create-ChocolateyBinFiles {
param(
  [string] $nugetChocolateyPath,
  [string] $chocolateyExePath
)

$chocolateyPathBash = $nugetChocolateyPath.Replace("%DIR%..\","`$DIR/../").Replace("\","/")

$nugetChocolateyBinFile = Join-Path $chocolateyExePath 'chocolatey.bat'
$nugetChocolateyBinFileAlias = Join-Path $chocolateyExePath 'choco.bat'
$nugetChocolateyInstallAlias = Join-Path $chocolateyExePath 'cinst.bat'
$nugetChocolateyUpdateAlias = Join-Path $chocolateyExePath 'cup.bat'
$nugetChocolateyUninstallAlias = Join-Path $chocolateyExePath 'cuninst.bat'
$nugetChocolateyListAlias = Join-Path $chocolateyExePath 'clist.bat'
$nugetChocolateyVersionAlias = Join-Path $chocolateyExePath 'cver.bat'
$nugetChocolateyPackAlias = Join-Path $chocolateyExePath 'cpack.bat'
$nugetChocolateyPushAlias = Join-Path $chocolateyExePath 'cpush.bat'


Write-Host "Creating `'$nugetChocolateyBinFile`' so you can call 'chocolatey' from anywhere."
"@SET DIR=%~dp0%
@""$nugetChocolateyPath\chocolatey.cmd"" %*" | Out-File $nugetChocolateyBinFile -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename $0).bat `$*""
exit `$?" | Out-File $nugetChocolateyBinFile.Replace(".bat","") -encoding ASCII 

Write-Host "Creating `'$nugetChocolateyBinFileAlias`' so you can call 'choco' from anywhere."
"@SET DIR=%~dp0%
@""$nugetChocolateyPath\chocolatey.cmd"" %*" | Out-File $nugetChocolateyBinFileAlias -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename $0).bat `$*""
exit `$?" | Out-File $nugetChocolateyBinFileAlias.Replace(".bat","") -encoding ASCII 

Write-Host "Creating `'$nugetChocolateyInstallAlias`' so you can call 'chocolatey install' from a shortcut of 'cinst'."
"@SET DIR=%~dp0%
@""$nugetChocolateyPath\chocolatey.cmd"" install %*" | Out-File $nugetChocolateyInstallAlias -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename $0).bat `$*""
exit `$?" | Out-File $nugetChocolateyInstallAlias.Replace(".bat","") -encoding ASCII 

Write-Host "Creating `'$nugetChocolateyUpdateAlias`' so you can call 'chocolatey update' from a shortcut of 'cup'."
"@SET DIR=%~dp0%
@""$nugetChocolateyPath\chocolatey.cmd"" update %*" | Out-File $nugetChocolateyUpdateAlias -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename $0).bat `$*""
exit `$?" | Out-File $nugetChocolateyUpdateAlias.Replace(".bat","") -encoding ASCII 

Write-Host "Creating `'$nugetChocolateyListAlias`' so you can call 'chocolatey list' from a shortcut of 'clist'."
"@SET DIR=%~dp0%
@""$nugetChocolateyPath\chocolatey.cmd"" list %*" | Out-File $nugetChocolateyListAlias -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename $0).bat `$*""
exit `$?" | Out-File $nugetChocolateyListAlias.Replace(".bat","") -encoding ASCII 

Write-Host "Creating `'$nugetChocolateyVersionAlias`' so you can call 'chocolatey version' from a shortcut of 'cver'."
"@SET DIR=%~dp0%
@""$nugetChocolateyPath\chocolatey.cmd"" version %*" | Out-File $nugetChocolateyVersionAlias -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename $0).bat `$*""
exit `$?" | Out-File $nugetChocolateyVersionAlias.Replace(".bat","") -encoding ASCII 

Write-Host "Creating `'$nugetChocolateyPackAlias`' so you can call 'chocolatey pack' from a shortcut of 'cpack'."
"@SET DIR=%~dp0%
@""$nugetChocolateyPath\chocolatey.cmd"" pack %*" | Out-File $nugetChocolateyPackAlias -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename $0).bat `$*""
exit `$?" | Out-File $nugetChocolateyPackAlias.Replace(".bat","") -encoding ASCII 

Write-Host "Creating `'$nugetChocolateyPushAlias`' so you can call 'chocolatey push' from a shortcut of 'cpush'."
"@SET DIR=%~dp0%
@""$nugetChocolateyPath\chocolatey.cmd"" push %*" | Out-File $nugetChocolateyPushAlias -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename $0).bat `$*""
exit `$?" | Out-File $nugetChocolateyPushAlias.Replace(".bat","") -encoding ASCII 

Write-Host "Creating `'$nugetChocolateyUninstallAlias`' so you can call 'chocolatey uninstall' from a shortcut of 'cuninst'."
"@SET DIR=%~dp0%
@""$nugetChocolateyPath\chocolatey.cmd"" uninstall %*" | Out-File $nugetChocolateyUninstallAlias -encoding ASCII

"#!/bin/sh
""`$SYSTEMROOT/System32/cmd.exe"" /c ""`$(basename $0).bat `$*""
exit `$?" | Out-File $nugetChocolateyUninstallAlias.Replace(".bat","") -encoding ASCII 

}

function Initialize-Chocolatey {
<#
	.DESCRIPTION
		This will initialize the Chocolatey tool by
			a) setting up the "nugetPath" (the location where all chocolatey nuget packages will be installed)
			b) Installs chocolatey into the "nugetPath"
            c) Instals .net 4.0 if needed
			d) Adds chocolaty to the PATH environment variable so you have access to the chocolatey|cinst commands.
	.PARAMETER  NuGetPath
		Allows you to override the default path of (C:\Chocolatey\) by specifying a directory chocolaty will install nuget packages.

	.EXAMPLE
		C:\PS> Initialize-Chocolatey

		Installs chocolatey into the default C:\Chocolatey\ directory.

	.EXAMPLE
		C:\PS> Initialize-Chocolatey -nugetPath "D:\ChocolateyInstalledNuGets\"

		Installs chocolatey into the custom directory D:\ChocolateyInstalledNuGets\

#>
param(
  [Parameter(Mandatory=$false)][string]$chocolateyPath = "$sysDrive\Chocolatey"
)

  #if we have an already environment variable path, use it.
  $alreadyInitializedNugetPath = Get-ChocolateyInstallFolder
  if($alreadyInitializedNugetPath -and $alreadyInitializedNugetPath -ne $chocolateyPath -and $alreadyInitializedNugetPath -ne $defaultChocolateyPathOld){
    $chocolateyPath = $alreadyInitializedNugetPath
  }
  else {
    Set-ChocolateyInstallFolder $chocolateyPath
  }

  if(!(test-path $chocolateyPath)){
    mkdir $chocolateyPath | out-null
  }

  #set up variables to add
  $chocolateyExePath = Join-Path $chocolateyPath 'bin'
  $chocolateyLibPath = Join-Path $chocolateyPath 'lib'
  $nugetChocolateyPath = Join-Path $chocolateyPath 'chocolateyinstall'

  $nugetYourPkgPath = [System.IO.Path]::Combine($chocolateyLibPath,"yourPackageName")
@"
We are setting up the Chocolatey repository for NuGet packages that should be at the machine level. Think executables/application packages, not library packages.
That is what Chocolatey NuGet goodness is for.
The repository is set up at `'$chocolateyPath`'.
The packages themselves go to `'$chocolateyLibPath`' (i.e. $nugetYourPkgPath).
A batch file for the command line goes to `'$chocolateyExePath`' and points to an executable in `'$nugetYourPkgPath`'.

Creating Chocolatey NuGet folders if they do not already exist.

"@ | Write-Host

  #create the base structure if it doesn't exist
  Create-DirectoryIfNotExists $chocolateyExePath
  Create-DirectoryIfNotExists $chocolateyLibPath
  Create-DirectoryIfNotExists $nugetChocolateyPath
  
  Upgrade-OldNuGetDirectory $defaultChocolateyPathOld $chocolateyPath
  
  Install-ChocolateyFiles $chocolateyPath
  
  $chocolateyExePathVariable = $chocolateyExePath.ToLower().Replace($chocolateyPath.ToLower(), "%DIR%..\").Replace("\\","\")
  Create-ChocolateyBinFiles $nugetChocolateyPath.ToLower().Replace($chocolateyPath.ToLower(), "%DIR%..\").Replace("\\","\") $chocolateyExePath
  Initialize-ChocolateyPath $chocolateyExePath $chocolateyExePathVariable
  Process-ChocolateyBinFiles $chocolateyExePath $chocolateyExePathVariable
  Install-DotNet4IfMissing
  
@"
Chocolatey is now ready.
You can call chocolatey from anywhere, command line or powershell by typing chocolatey.
Run chocolatey /? for a list of functions.
You may need to shut down and restart powershell and/or consoles first prior to using chocolatey.
If you are upgrading chocolatey from an older version (prior to 0.9.8.15) and don't use a custom chocolatey path, please find and delete the C:\NuGet folder after verifying that C:\Chocolatey has the same contents (minus chocolateyinstall of course).
"@ | write-host
}

function Install-DotNet4IfMissing {
    if([IntPtr]::Size -eq 8) {$fx="framework64"} else {$fx="framework"}
    if(!(test-path "$env:windir\Microsoft.Net\$fx\v4.0.30319")) {
        "Downloading and installing .NET 4.0 Framework" | Write-Host
        $env:chocolateyPackageFolder="$env:temp\chocolatey\webcmd"
        Import-Module $env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1
        Install-ChocolateyZipPackage 'webcmd' 'http://www.iis.net/community/files/webpi/webpicmdline_anycpu.zip' $env:temp
        Start-ChocolateyProcessAsAdmin ".'$env:temp\WebpiCmdLine.exe' /products: NetFramework4 /SuppressReboot /accepteula"
        Remove-Module ChocolateyInstaller
    }
}

function Upgrade-OldNuGetDirectory {
param(
  [string]$chocolateyPathOld = "$sysDrive\NuGet",
  [string]$chocolateyPath = "$sysDrive\NuGet"
)

  if((test-path $defaultChocolateyPathOld)){
    Write-Host "Upgrading `'$chocolateyPathOld`' to `'$chocolateyPath`'."
    
    Write-Host "Copying the contents of `'$chocolateyPathOld`' to `'$chocolateyPath`'. This step may fail if you have anything in this folder running or locked."
    Write-Host 'If it fails, just manually copy the rest of the items out and then delete the folder.'
    Copy-Item "$($chocolateyPathOld)\*" "$chocolateyPath" -force -recurse
    #write-host "Attempting to remove `'$chocolateyPathOld`'. This may fail if something in the folder is being used or locked. If it fails, same idea as above."
    #Remove-Item "$($chocolateyPathOld)" -force -recurse
    
    $chocolateyExePathOld = Join-Path $chocolateyPathOld 'bin'
    $statementTerminator = ";"
    #get the PATH variable
    $envPath = $env:PATH
    #remove the old environment variable
    if ($envPath.Contains($chocolateyExePathOld)) {
      Write-Host "Attempting to remove older `'$chocolateyExePathOld`' from the PATH."
      $userPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
      if ($userPath.Contains($chocolateyExePathOld)) {
        $userPath = $userPath.Replace("$chocolateyExePathOld","").Replace("$chocolateyExePathOld);","")
        [Environment]::SetEnvironmentVariable('Path', $userPath, [System.EnvironmentVariableTarget]::User)
      } else {
        Write-Host "Chocolatey was not able to remove `'$chocolateyExePathOld`' automatically. It's likely in the system's path instead of the user path, but it could be due to other factors (including casing). Please manually find and remove it from either the user PATH or the machine PATH."
      }
    }
  }
}

function Install-ChocolateyFiles {
param(
  [string]$chocolateyPath = "$sysDrive\Chocolatey"
)
  #$chocInstallFolder = Get-ChildItem .\ -Recurse | ?{$_.name -match  "chocolateyInstall*"} | sort name -Descending | select -First 1 
  #$thisScript = (Get-Variable MyInvocation -Scope 1).Value 
  #$thisScriptFolder = Split-Path $thisScript.MyCommand.Path
  
  $chocInstallFolder = Join-Path $thisScriptFolder "chocolateyInstall"
  Write-Host "Copying the contents of `'$chocInstallFolder`' to `'$chocolateyPath`'."
  if(test-path "$chocolateyPath\chocolateyInstall\functions") {
    Remove-Item "$chocolateyPath\chocolateyInstall\functions" -recurse -force 
  }
  if(test-path "$chocolateyPath\chocolateyInstall\helpers") {
    Remove-Item "$chocolateyPath\chocolateyInstall\helpers" -recurse -force 
  }
  Copy-Item $chocInstallFolder $chocolateyPath -recurse -force
}

function Initialize-ChocolateyPath {
param(
  [string]$chocolateyExePath = "$sysDrive\Chocolatey\bin",
  [string]$chocolateyExePathVariable = "%$($chocInstallVariableName)%\bin"
)

  $statementTerminator = ";"
  #get the PATH variable
  $envPath = $env:PATH
  
  #if you do not find $chocolateyPath\bin, add it 
  if (!$envPath.ToLower().Contains($chocolateyExePath.ToLower())) # -and !$envPath.ToLower().Contains($chocolateyExePathVariable))
  {
    Write-Host ''
    #now we update the path
    Write-Host "PATH environment variable does not have `'$chocolateyExePath`' in it. Adding."
    #Write-Host 'PATH environment variable does not have ' $chocolateyExePathVariable ' in it. Adding.'
    $userPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
  
    #does the path end in ';'?
    $hasStatementTerminator = $userPath -ne $null -and $userPath.EndsWith($statementTerminator)
    # if the last digit is not ;, then we are adding it
    If (!$hasStatementTerminator -and $userPath -ne $null) {$chocolateyExePath = $statementTerminator + $chocolateyExePath}
    $userPath = $userPath + $chocolateyExePath + $statementTerminator

    [Environment]::SetEnvironmentVariable('Path', $userPath, [System.EnvironmentVariableTarget]::User)

    #add it to the local path as well so users will be off and running
    $envPSPath = $env:PATH
    $env:Path = $envPSPath + $statementTerminator + $chocolateyExePath + $statementTerminator
    #$env:ChocolateyInstall = $chocolateyExePath
  } else {
    write-host "User PATH already contains either `'$chocolateyExePath`' or `'$chocolateyExePathVariable`'"
  }
}

function Process-ChocolateyBinFiles {
param(
  [string]$chocolateyExePath = "$($env:SystemDrive)\Chocolatey\bin",
  [string]$chocolateyExePathVariable = "%$($chocInstallVariableName)%\bin"
)
  $processedMarkerFile = Join-Path $chocolateyExePath '_processed.txt'
  if (!(test-path $processedMarkerFile)) {
    $files = get-childitem $chocolateyExePath -include *.bat -recurse
    foreach ($file in $files) {
      Write-Host "Processing $($file.Name) to make it portable"
      $fileStream = [System.IO.File]::Open("$file", 'Open', 'Read', 'ReadWrite')
      $reader = New-Object System.IO.StreamReader($fileStream)
      $fileText = $reader.ReadToEnd()
      $reader.Close()
      $fileStream.Close()
      
      $fileText = $fileText.ToLower().Replace("`"" + $chocolateyPath.ToLower(), "SET DIR=%~dp0%`n""%DIR%..\").Replace("\\","\")
      
      Set-Content $file -Value $fileText -Encoding Ascii
    }
    
    Set-Content $processedMarkerFile -Value "$([System.DateTime]::Now.Date)" -Encoding Ascii
  }
}

export-modulemember -function Initialize-Chocolatey;