## Restricted

Get-ExecutionPolicy -list

Set-ExecutionPolicy Unrestricted

Get-ExecutionPolicy 

## Unrestricted

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Install-Module -Name SqlServer


# ADVERTENCIA: La versión '21.1.18245' del módulo 'SqlServer' ya está instalada en 'C:\Program Files\WindowsPowerShell\Modules\SqlServer\21.1.18245'. Para instalar la versión '21.1.182
# 56', ejecuta Install-Module y agrega el parámetro -Force; este comando instalará la versión '21.1.18256' en paralelo con la versión '21.1.18245'.


import-module sqlserver


Get-Module -ListAvailable -Name *SQLServer*

# Script     21.1.18245 SqlServer                           {Add-RoleMember, Add-SqlAvailabilityDatabase, Add-SqlAvailabilityGroupListenerStaticIp, Add-SqlAzureAuthenticationContex...

############################################
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned 

set-executionpolicy unrestricted

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module -Name SqlServer -AllowClobber

Install-Module -Name SqlServer

Install-Module -Name SqlServer -AllowPrerelease

install-PackageProvider -name Nuget -minimunversion 2.8.5.201 -Force

Get-InstalledModule -Name "SqlServer"

#####################################################


Get-Service -Name *SQL*

Get-Command -Module SqlServer -CommandType Cmdlet | Out-GridView 

Get-Command -Module SqlServer 


Get-Command -Module SqlServer -CommandType Cmdlet

Clear-Host

##################










Install-Module dbatools 

https://dbatools.io/soup2nutz/

Install-Module dbatools -Scope CurrentUser

# verify you have dbatools module installed
Get-InstalledModule -Name "dbatools"	

# 1.1.142    dbatools                            PSGallery            The community module that enables SQL Server Pros to automate database development and server administration     


# Quick overview of commands
Start-Process https://dbatools.io/commands

Get-DbaService -ComputerName .
Import-Module dbatools

Enable-DbaFilestream -SqlInstance CMM -FileStreamLevel 1
##SERVICES




# Almacena los BACKUPS en C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup

Backup-SqlDatabase -ServerInstance "localhost" -Database "Pubs"

Backup-SqlDatabase -ServerInstance "localhost" -Database "Northwind"
	
Get-SqlDatabase -ServerInstance "localhost" | Where { $_.Name -ne 'tempdb' } | Backup-SqlDatabase

# Backup completo
$dt = Get-Date -Format yyyyMMddHHmmss
$instancename = "localhost"
$dbname = 'Northwind'
Backup-SqlDatabase -Serverinstance $instancename -Database $dbname -BackupFile "c:\BACKUP\$($dbname)_db_$($dt).bak"

#Nombre del backup: Pubs_db_20221202161742.bak

#Fin backup


###################
help invoke-sqlcmd
Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery" -ServerInstance "."

Invoke-Sqlcmd -Query "SELECT COUNT(*) AS Count FROM Authors" -ConnectionString "Data Source=.;Initial Catalog=Pubs;Integrated Security=True;ApplicationIntent=ReadOnly"


# Antes del restore

Invoke-Sqlcmd -Serverinstance localhost -Database Pubs -Query 'Alter Database Pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;'
Invoke-Sqlcmd -Serverinstance localhost -Database Pubs -Query 'Alter Database Pubs SET MULTI_USER WITH ROLLBACK IMMEDIATE;'
#borrar Pubs
Restart-Service "MSSQLSERVER" -Force

Invoke-Sqlcmd -Serverinstance localhost -Query "Drop database Pubs;"
#restore
Restore-Sqldatabase -Serverinstance $instancename -Database $dbname -Backupfile "C:\BACKUP\Pubs_db_20221202161742.bak" -replacedatabase
#fin restore



# Ejecutar SQL con Invoke-SqlCmd
Invoke-SqlCmd -ServerInstance localhost -InputFile "C:\scripts\Create_MyDatabase.sql"



# Funciones
# Creamos una funcion para obtener el usuario actual
Function UsuarioActual 
{ [System.Security.Principal.WindowsIdentity]::GetCurrent().Name }

# Ejecutamos la funcion
UsuarioActual




# Utilizamos la ayuda sobre Invoke-sqlcmd
help invoke-sqlcmd -ShowWindow

# Pregunto por la versión del SQL
invoke-sqlcmd -query "select @@version"

# Pregunto por la fecha actual
invoke-sqlcmd -query "SELECT GETDATE() AS TimeOfQuery;" -ServerInstance "localhost"

# Consulta de una tabla de mi base de datos (OGV es el alias de Out-GridView)
invoke-sqlcmd -Query "SELECT * FROM Authors;" -Database 'Pubs' | ogv

# Vamos a obtener las bases de datos de dos formas diferentes

# Con una select de los nombres de las bases de datos
invoke-sqlcmd -serverinstance "localhost" -database master -Query "SELECT name From Sys.databases" | ogv

# Utilizamos un procedimiento almacenado
invoke-sqlcmd -serverinstance "localhost" -database master -Query "EXEC sp_databases" | ogv


#######Archivo 3########


GET-INSTALLedModule -Name "sqlserver"

Install-Module -Name "sqlserver"

New-Item "C:\Scripts_ps" -itemType Directory

New-Item "C:\BD" -ItemType Directory

Invoke-sqlcmd -ServerInstance localhost -Query "DROP DATABASE MyDatabase"

Invoke-sqlcmd -ServerInstance localhost -InputFile C:\scripts\Create_MyDatabase.sql

####################
# Crear variables con SQL Dinámico
$sql = "
CREATE DATABASE [MyDatabase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MyDatabase', FILENAME = N'C:\Data\MyDatabase.mdf' , SIZE = 1048576KB , FILEGROWTH = 262144KB )
 LOG ON 
( NAME = N'MyDatabase_log', FILENAME = N'C:\Data\MyDatabase_log.ldf' , SIZE = 524288KB , FILEGROWTH = 131072KB )
GO
 
USE [master]
GO
ALTER DATABASE [MyDatabase] SET RECOVERY SIMPLE WITH NO_WAIT
GO
 
ALTER AUTHORIZATION ON DATABASE::[MyDatabase] TO [sa]
GO
"
Invoke-Sqlcmd -ServerInstance localhost -Query $sql


# Verificar que tenemos dba tools

Get-InstalledModule -Name "dbatools"

Install-Module -Name "dbatools"

$sqlinstance = 'localhost'
$Name = 'MiDatabaseTools'
$DatafilePath = 'C:\BD' # data file path
$LogFilePath = 'C:\BD' # log file path
$Recoverymodel = 'Simple'
$Owner = 'sa'
$PrimaryFilesize = 1024
$PrimaryFileGrowth = 256
$LogSize = 512
$LogGrowth = 128

# New-DbaDatabase -SqlInstance $sqlinstance -Name $Name -DataFilePath $DatafilePath -LogFilePath $LogFilePath

Get-DbaDatabase -SqlInstance $sqlinstance -Database $name

