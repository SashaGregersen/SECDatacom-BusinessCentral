# Netcompany's AL application foundatio for SEC Datacoms Microsoft Dynamics 365 Business Central
Welcome to SEC Datacoms ALAppExtension repository!

This repo is a platform for Netcompany to work together to develop extension module in the AL language of Microsoft Dynamics 365 Business Central for SEC Datacom.

## Getting Started

These instructions will get you a copy of the project up and running on a given system.

1. Check if the development envoirment have generatesymbolreference set to yes as a command line argument each time you start finsql.exe to have all compilations add a symbol reference to the Object Metadata table. The default setting of the argument is no.
```
finsql.exe generatesymbolreference=yes
```
2. Download the .app-file to the targetet location.
3. Run Windows PowerShell ISE as Administrator and run the following script with your changes.
```
Import-Module "$env:ProgramFiles\Microsoft Dynamics 365 Business Central\140\Service\NavAdminTool.ps1" -WarningAction SilentlyContinue | Out-Null

$NAVServerInstance = 'BC140'
$AppPathAndFilename = "C:\Users\UserName\Documents\Christopher Hornsyld_ALProject_1.0.0.0.app"
$AppName = "ALProject"
$AppVersion = '1.0.0.0'

publish-NAVApp -ServerInstance $NAVServerInstance -Path $AppPathAndFilename -SkipVerification

install-NAVApp -ServerInstance $NAVServerInstance -Name $AppName
```

If you need to uninstall an app-extension you can use the following 

```
Uninstall-NAVApp -ServerInstance $NAVServerInstance -Name $AppName -Version $AppVersion

Unpublish-NAVApp -ServerInstance $NAVServerInstance -Name $AppName -Version $AppVersion
```
