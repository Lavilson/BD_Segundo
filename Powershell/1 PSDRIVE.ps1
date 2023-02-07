PSDRIVE
Get-Location
Install-Module -Name SqlServer
Install-Module -Name SqlServer -AllowClobber
Get-Module SqlServer -ListAvailable
Update-Module -Name SqlServer -AllowClobber
Find-Module SqlServer 
PSDRIVE
Import-Module SqlServer
PSDRIVE
CD SQLSERVER:\
Get-Location

## Shows using the full cmdet name.  
Set-Location SQLSERVER:\SQL  
Get-ChildItem  

# DESKTOP-V9719B2                 

## Shows using canonical aliases.  
sl SQLSERVER:\SQL  
gci  
  
## Shows using command prompt aliases.  
cd SQLSERVER:\SQL  
dir  
  
## Shows using Unix shell aliases.  
cd SQLSERVER:\SQL  
ls

## List the instances of the Database Engine on the local computer.  
  
Set-Location SQLSERVER:\SQL\localhost  
Get-ChildItem  
  
## Lists the categories of objects available in the  
## default instance on the local computer.  
Set-Location SQLSERVER:\SQL\localhost\DEFAULT  
Get-ChildItem  
  
## Lists the databases from the local default instance.  
## The force parameter is used to include the system databases.  
Set-Location SQLSERVER:\SQL\localhost\DEFAULT\Databases  
Get-ChildItem -force

ls

Set-Location pubs

ls

Set-Location Tables

