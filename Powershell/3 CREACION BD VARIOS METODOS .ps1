Get-InstalledModule -Name "SqlServer"

Install-Module -Name "SqlServer"

New-Item "C:\Scripts" -itemType Directory

New-Item "C:\BD" -itemType Directory

Invoke-SqlCmd -ServerInstance localhost -Query "DROP DATABASE MyDatabase"

Invoke-SqlCmd -ServerInstance localhost -InputFile C:\scripts\Create_MyDatabase.sql

##############################
# create variable with SQL to execute
$sql = "
CREATE DATABASE [MyDatabase]
 CONTAINMENT = NONE
 ON  PRIMARY
( NAME = N'MyDatabase', FILENAME = N'C:\BD\MyDatabase.mdf' , SIZE = 1048576KB , FILEGROWTH = 262144KB )
 LOG ON
( NAME = N'MyDatabase_log', FILENAME = N'C:\BD\MyDatabase_log.ldf' , SIZE = 524288KB , FILEGROWTH = 131072KB )
GO

USE [master]
GO
ALTER DATABASE [MyDatabase] SET RECOVERY SIMPLE WITH NO_WAIT
GO

ALTER AUTHORIZATION ON DATABASE::[MyDatabase] TO [sa]
GO "


Invoke-SqlCmd -ServerInstance localhost -Query $sql

################################

# Method # 2 - Create SQL Server Database Using PowerShell and SQL Server Management Object (SMO)


# import SqlServer module
Import-Module -Name "SqlServer"
 

$server= new-object Microsoft.Sqlserver.management.smo.server 'localhost' 
$dbname= "ASIB" 
$db=new-object Microsoft.Sqlserver.management.smo.Database ($server,$dbname)

$db.Create() 
 
# set recovery model
$db.RecoveryModel = "simple"
$db.Alter()
 
# change owner
$db.SetOwner('sa')
 
# change data file size and autogrowth amount
foreach($datafile in $db.filegroups.files) 
{
 $datafile.size= 1048576
 $datafile.growth = 262144
 $datafile.growthtype = "kb"
 $datafile.alter()
}
 
# change log file size and autogrowth
foreach($logfile in $db.logfiles)
{
 $logfile.size= 524288
 $logfile.growth = 131072
 $logfile.growthtype = "kb"
 $logfile.alter()
} 
			
################################33

# Method # 3 - Create SQL Server Database Using PowerShell and dbatools

# verify you have dbatools module installed
Get-InstalledModule -Name "dbatools"	

Install-Module -Name "dbatools"



$SqlInstance = 'localhost'                                                   # SQL Server name 
$Name = 'MyDatabaseDDATOOLS'                                                                # database name
$DataFilePath = 'C:\BD\' # data file path
$LogFilePath = 'C:\BD\'  # log file path
$Recoverymodel = 'Simple'                                                           # recovery model
$Owner = 'sa'                                                                       # database owner
$PrimaryFilesize = 1024                                                             # data file initial size
$PrimaryFileGrowth = 256                                                            # data file autrogrowth amount
$LogSize = 512                                                                      # data file initial size
$LogGrowth = 128                                                                    # data file autrogrowth amount
 
 New-DbaDatabase -SqlInstance $SqlInstance -Name $Name -DataFilePath $DataFilePath -LogFilePath $LogFilePath -Recoverymodel $Recoverymodel -Owner $Owner -PrimaryFilesize $PrimaryFilesize -PrimaryFileGrowth $PrimaryFileGrowth -LogSize $LogSize -LogGrowth $LogGrowth | Out-Null

Get-DbaDatabase -SqlInstance $SqlInstance -Database $Name
