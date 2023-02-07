$PSVersionTable

# PSVersion                      5.1.19041.1682                                                                                                                                        


# Pueba con concepto de variable
$version=$PSVersionTable
$version

##############################################3

# Installing PowerShell on Windows
# https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2
#PowerShell 7.2
# Installing the MSI package

# Once downloaded, double-click the installer file and follow the prompts.

#The installer creates a shortcut in the Windows Start Menu.

#By default the package is installed to $env:ProgramFiles\PowerShell\<version>
# You can launch PowerShell via the Start Menu or $env:ProgramFiles\PowerShell\<version>\pwsh.exe
# Note

#PowerShell 7.2 installs to a new directory and runs side-by-side with Windows PowerShell 5.1. PowerShell 7.2 is an in-place upgrade that replaces PowerShell 7.0 and lower.

#PowerShell 7.2 is installed to $env:ProgramFiles\PowerShell\7
#The $env:ProgramFiles\PowerShell\7 folder is added to $env:PATH
#Folders for previously released versions are deleted
# If you need to run PowerShell 7.2 side-by-side with other versions, use the ZIP install method to install the other version to a different folder.

######################################



# Ayuda
Show-Command

# Ayuda en PS

Get-Help 
Get-Help -Full
Get-Help -ShowWindow

Update-Help

help cmdlet -Full
help Get-Service -ShowWindow
help *network* -ShowWindow
help Get-DisplayResolution


# Funcionan comandos habituales externos
ping localhost
ipconfig

## Borrar pantalla
Clear-Host

#Cmdlets ejecutados
Get-History


# Policy Execution Script

##########
Restricted - No scripts can be run. Windows PowerShell can be used only in interactive mode.
AllSigned - Only scripts signed by a trusted publisher can be run.
RemoteSigned - Downloaded scripts must be signed by a trusted publisher before they can be run.
Unrestricted - No restrictions; all Windows PowerShell scripts can be run.
##########


Help Get-ExecutionPolicy -ShowWindow
Help Set-ExecutionPolicy -ShowWindow
Get-ExecutionPolicy
Set-ExecutionPolicy
Set-ExecutionPolicy RemoteSigned
Set-ExecutionPolicy Unrestricted


# Manipulando Entorno
# Displays the name of the default options. 
$psISE.Options.DefaultOptions
# Sets the foreground to color of non-script files in the script pane to green.
$psISE.Options.ScriptPaneBackgroundColor = ”green”
$psISE.Options.RestoreDefaults()
# Changes the background color of the Command Pane to orange. 
$psISE.Options.ConsolePaneBackgroundColor= "blue"
# Changes the font used in all the panes. 
$psISE.Options.FontName = "courier new"
# Changes the font size in all the panes.
$psISE.Options.FontSize = 16
$psISE.Options.Zoom = 175
$psISE.Options.RestoreDefaults()
## 


# ALIAS

alias
get-alias ls
#dir is an alias for the cmdlet Get-ChildItem
dir
get-alias ft
# ft -> Format-Table
# Obtenet Alias de un cmdlet
get-alias -Definition "Get-Service"

# Crear nuestros alias temporales
new-alias -Name d -Value get-childitem
d
# Posibilidad de importar / exportar
# Desaparecen con la sesión
#list all aliases 
Get-Alias

#get members of Get-Alias
Get-Alias | Get-Member

#list cmdlet that is aliased as dir
$alias:dir

#list cmdlet that is aliased as ls
$alias:ls

#get all aliases of Get-ChildItem
Get-Alias -Definition "Get-ChildItem"

## Variables
$Process = Get-Process
$alias:ogv
$Process|ogv
## Variables de entorno
dir env:U*
##write-host "Bonjour $(env:USERNAME)" –fore 'green'
$Host.version.major
# Contar cmdlets
(Get-Command –CommandType cmdlet).count

gcm –CommandType cmdlet | group verb | sort count –Descending
[datetime]::now

Powershell.exe –ExecutionPolicy bypass –file monscript.ps1

<#
PSProvider and PSDrive: PowerShell allows different data stores to be accessed as if
they are regular files and folders. PSProvider is similar to an adapter, which allows
these data stores to be seen as drives.
#>
Get-PSProvider
Get-PSDrive
psdrive
Set-Location -Path C:\Windows
cd \
cd C:\Users\manuel
Remember the New-Item cmdlet is generic—it doesnt know you want to create a
folder. It can create folders, files, registry keys, and much more, but you have to tell it
what type of item you want to create       .Posibles: File y directory

new-item NuevaCarpeta
get-help *-item*
remove-item NuevaCarpeta
cd hkcu:
dir
cd software
dir | gm
gm is get members

gc env:computername

#Servicios
Get-Service
# Preguntar por un servicio en un equipo
get-service -Name adws -ComputerName CMM
#Usando Parámetros en un comando . Obligatorio o no
Get-ChildItem c:\users
Get-ChildItem -path c:\users

# Pipeline . Envio a Ficheros
get-process
get-process | out-file c:\procesos.txt
notepad c:\procesos.txt
Get-Process | Export-CSV procs.csv
notepad .\procs.csv


Get-EventLog –LogName System |Export-Csv c:\IISErrors.csv
notepad c:\IISErrors.csv


Get-Process | `
 Where-Object ProcessName –EQ 'sqlservr' | 
 ` Export-CSV -Path $env:TEMP\SQLProcesses.txt -Delimiter ":" 
Notepad $env:TEMP\SQLProcesses.txt

Get-Process | Out-Null 
Get-Process | Out-Host 
Get-Process | Out-File $env:TEMP\ProcessList.txt 
Get-Process | Out-Printer 
Get-Process | Out-String 
Get-Process | Out-Default 
Get-Process | Out-GridView


get-alias ?

get-alias ft
# ft -> Format-Table
get-service | ft Name, MachineName, CanStop -auto

## Operadores
Help About_Operators 
Help about_Arithmetic_Operators
Help about_Assignment_Operators
Help about_Comparison_Operators
Help about_Logical_Operators
Help about_Type_Operators
Help about_Split
Help about_Join
Help about_Redirection

#####################
The -like keyword is an example of a comparison operator in Windows PowerShell. A list of these comparison operators is shown below

-lt: Less than
-le : Less than or equal to
-gt: Greater than
-ge : Greater than or equal to
-eq : Equal to
-ne : Not equal to
-like : Like; uses wildcards for pattern matching


Get-Command Format-*

Get-Process | Where-Object {$_.PrivateMemorySize -gt 50MB}

Get-Process | Where-Object {$_.PrivateMemorySize -gt 50MB} | SELECT ProcessName, PrivateMemorySize, CPU | Format-List

Get-Process | Where-Object {$_.PrivateMemorySize -gt 50MB} | SELECT ProcessName, PrivateMemorySize, CPU | Export-CSV c:\process.csv 




######################

# Flujos de Codigo

$(get-service | where { $_.Name –eq “winrm” })

get-service | ?{$_.Name -eq "Dhcp"}

get-service | ?{$_.Name -eq "wuauserv"}
get-service | ?{$_.Name -eq "wuauserv"} | %{$_.Start()}
get-service | ?{$_.Name -eq "wuauserv"}
get-service | ?{$_.Name -eq "wuauserv"} | %{$_.Stop()}
Get-Service | Stop-Service -confirm

# Inicio
Get-Service | where-Object{$_.name -like '*sql*'} | Format-Table –AutoSize
#Start-Service "SQLSERVERAGENT"
#Stop-Service "SQLSERVERAGENT"
# Final
Get-Service | where-Object{$_.name -like '*sql*'} | Format-Table –AutoSize


help about_Language_Keywordsc:\AyudaKeywords.txt
notepad c:\AyudaKeywords.txt

help about_if | out-file c:\AyudaIf.txt
notepad c:\AyudaIf.txt

help about_switch
help about_for
help about_foreach
help about_do
help about_while

## Invoke-Command
Invoke-Command -ScriptBlock { Get-WMIObject Win32_BIOS }

# Funciones
help about_functionsout-file c:\AyudaFunciones.txt
notepad c:\AyudaFunciones.txt

## Con Parametros
function dump-file {
param ($Ruta=$PWD,$Archivo)
get-content “$Ruta\$Archivo”
}

function dump-file {
param ($Chemin=$PWD,
$Fichier)
get-content “$Chemin\$Fichier”
}

#dump-file C:\Temp ComputerName.txt
#dump-file –Chemin C:\Temp –Fichier ComputerName.txt

dump-file C:\Temp Personas.csv
dump-file –Chemin C:\Temp –Fichier Personas.csv

## Ejemplo Función
Function Get-WMIServices
{
Get-WmiObject win32_service |
Select-Object State,Name,DisplayName,StartMode
}
Echo "Script Fin."
$Resultados = Get-WMIServices
$Resultados
##
Get-ExecutionPolicy 

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



##################

############################

# https://dbatools.io/download/

Install-Module dbatools 

https://dbatools.io/soup2nutz/

Install-Module dbatools -Scope CurrentUser

# verify you have dbatools module installed
Get-InstalledModule -Name "dbatools"	

# 1.1.142    dbatools                            PSGallery            The community module that enables SQL Server Pros to automate database development and server administration     


# Quick overview of commands
Start-Process https://dbatools.io/commands

Get-DbaService -ComputerName .

Enable-DbaFilestream -SqlInstance CMM -FileStreamLevel 1
##SERVICES

# Arrancar y detener servicios de SQL
# Primero importamos el modulo de SQLPS
Import-Module SQLPS -DisableNameChecking

# Consultamoslos servicios del sistema y la salida es en ua ventana
Get-Service | Out-GridView

# Consultamoslos servicios del sistema que contienen sql(en formato tabla)
Get-Service | where-Object{$_.name -like '*sql*'} | Format-Table –AutoSize

# Consultamoslos servicios del sistema que contienen sql con salida Out-GridView
Get-Service | where-Object{$_.name -like '*sql*'} | Out-GridView

# Lo mismo pero con ALIAS ( ? = where-Object) y (ogv = Out-GridView)
Get-Service | ?{$_.name -like '*sql*'} | ogv

# Arrancar el servicio
Start-Service "SQLSERVERAGENT"

# Detener el servicio
Stop-Service "SQLSERVERAGENT"
# Control de flujo

# Consultamos los servicios
Get-service 

# Queremos los servicios que estan detenidos
# La ? es un alias para el cmdlet WHERE OBJECT y hace que entremos en una estructura repetitiva  {}
# $_ sustituye a Get-services
# Eq significa: igual a
Get-service | ?{$_.Status –eq “Stopped”}

# Comprobamos el status del servicio “Optimizar unidades ”
Get-service | ?{$_.Name –eq “defragsvc”}

# Iniciamos el servicio “Optimizar unidades ”
Get-service | ?{$_.Name –eq “defragsvc”} | %{$_.Start()}

# Comprobamos si esta iniciado el servicio “Optimizar unidades ”
Get-service | ?{$_.Name –eq “defragsvc”}

# Detenemos el servicio “Optimizar unidades ”
Get-service | ?{$_.Name –eq “defragsvc”} | %{$_.Stop()}

# Comprobamos si esta detenido el servicio “Optimizar unidades ”
Get-service | ?{$_.Name –eq “defragsvc”}

#############################

$SqlInstance = 'localhost'
$Name = 'Pubs'
Get-DbaDatabase -SqlInstance $SqlInstance -Database $Name

###################
help invoke-sqlcmd
Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery" -ServerInstance "."

Invoke-Sqlcmd -Query "SELECT COUNT(*) AS Count FROM Authors" -ConnectionString "Data Source=.;Initial Catalog=Pubs;Integrated Security=True;ApplicationIntent=ReadOnly"


Get-SqlInstance  -ServerInstance localhost

Get-SqlInstance --ServerInstance "localhost"

Get-SqlInstance -ServerInstance localhost | 
Invoke-SqlAssessment -Check maxmemory -FlattenOutput;


# History
Get-Command -Module dbatools *history*

######################


# Almacena los BACKUPS en C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup

Backup-SqlDatabase -ServerInstance "localhost" -Database "Pubs"

Backup-SqlDatabase -ServerInstance "localhost" -Database "Northwind"
	
Get-SqlDatabase -ServerInstance "localhost" | Where { $_.Name -ne 'tempdb' } | Backup-SqlDatabase

# Backup completo
$dt = Get-Date -Format yyyyMMddHHmmss
$instancename = "localhost"
$dbname = 'Pubs'
Backup-SqlDatabase -Serverinstance $instancename -Database $dbname -BackupFile "c:\BACKUP\$($dbname)_db_$($dt).bak"

#Nombre del backup: Pubs_db_20221202161742.bak

#Fin backup

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
Invoke-SqlCmd -ServerInstance localhost -InputFile "C:\DATABASES EXAMPLES\Create_MyDatabase.sql"

#
# Funciones
# Creamos una funcion para obtener el usuario actual
Function UsuarioActual 
{ [System.Security.Principal.WindowsIdentity]::GetCurrent().Name }

# Ejecutamos la funcion
UsuarioActual

## SMO
<#
 Sirve para ejecutar las sentencias de SQL y los scritps.
 Para poder ponerse en contacto con SQL necesita unas librerías. Disponemos de dos tipos de librerías:
 1. Agrupadas en SMO (SQLSERVER MANAGEMENT OBJECT)
 2. Agrupadas en ADO.NET (USADO PARA C#. ACTIVE DATA OBJECT)
#>

INVOKE-SQLCMD

# Debemos ir a SQL Server  features pack y descargar las librerías
# http://www.microsoft.com/en-au/download/details.aspx?id=42295

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

# Solo los nombres de las bases de datos del sistema
$SQL = New-Object("Microsoft.SqlServer.Management.Smo.Server") -ArgumentList "localhost"
$SQL.Databases.Name |ogv

# Toda la informacion  de las bases de datos del sistema
$Server = New-Object('Microsoft.SqlServer.Management.Smo.Server') -ArgumentList "localhost"
$Server.Databases |ogv

# Consulta de los usuarios del servidor usando SMO

Import-Module SQLSERVER -DisableNameChecking
$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$server.EnumWindowsUserInfo() | Out-GridView

##########################
# Using SQL Server Management Objects (SMO) objects 

#Name your database
$dbname = "ASIB"
# Create a SQL Server database object
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server("localhost")
if($null -ne $srv.Databases[$dbname])
{
    $db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, $dbname)

    # Create the database
    $db.Create()
}

#############################
#ERROR

#-- New-Object : No se encuentra el tipo [Microsoft.SqlServer.Management.Smo.Server]. Compruebe que está cargado el ensamblado que lo contiene.

#SOLUCION

## NECESITAMOS CARGAR MODULO SQLSERVER

Import-Module SQLSERVER

# Using SQL Server Management Objects (SMO) objects to do the heavy lifting:

#Name your database
$dbname = "ASIB"
# Create a SQL Server database object
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server("localhost")
if($null -ne $srv.Databases[$dbname])
{
    $db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, $dbname)

    # Create the database
    $db.Create()
}


#################
$backupFile = "\BACKUP\PubsBackup.bak"
Restore-SqlDatabase -ServerInstance YourInstance -Database Pubs -BackupFile $backupFile



# Assumes you are working from the package directory
Invoke-Sqlcmd -InputFile .\alter_script.sql -ServerInstance YourInstance -Database YourDB








#TESTANDO CONECTIVIDAD CON ADO.NET

#####################

try
{
    # This is a simple user/pass connection string.
    # Feel free to substitute "Integrated Security=True" for system logins.
    $connString = "Data Source=localhost;Database=Pubs;Integrated Security=True"

    #Create a SQL connection object
    $conn = New-Object System.Data.SqlClient.SqlConnection $connString

    #Attempt to open the connection
    $conn.Open()
    if($conn.State -eq "Open")
    {
        # We have a successful connection here
        # Notify of successful connection
        Write-Host "Test connection successful"
        $conn.Close()
    }
    # We could not connect here
    # Notify connection was not in the "open" state
}
catch
{
    # We could not connect here
    # Notify there was an error connecting to the database
}

################################

Invoke-Sqlcmd -Query "CREATE DATABASE YourDB" -ServerInstance YourInstance

##########################
# Using SQL Server Management Objects (SMO) objects to do the heavy lifting:

#Name your database
$dbname = "ASIB"
# Create a SQL Server database object
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server("localhost")
if($null -ne $srv.Databases[$dbname])
{
    $db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, $dbname)

    # Create the database
    $db.Create()
}

#############################
ERROR

-- New-Object : No se encuentra el tipo [Microsoft.SqlServer.Management.Smo.Server]. Compruebe que está cargado el ensamblado que lo contiene.

SOLUCION

NECESITAMOS CARGAR MODULO SQLSERVER

Import-Module SQLSERVER

# Using SQL Server Management Objects (SMO) objects to do the heavy lifting:

#Name your database
$dbname = "ASIB"
# Create a SQL Server database object
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server("localhost")
if($null -ne $srv.Databases[$dbname])
{
    $db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, $dbname)

    # Create the database
    $db.Create()
}


#################
$backupFile = "\BACKUP\PubsBackup.bak"
Restore-SqlDatabase -ServerInstance YourInstance -Database Pubs -BackupFile $backupFile



# Assumes you are working from the package directory
Invoke-Sqlcmd -InputFile .\alter_script.sql -ServerInstance YourInstance -Database YourDB









