##Start-Service sqlserveragent 

##Get-Service


############        Módulo SQLPS
Get-Command –Module SQLPS

#Cada vez que en una nueva sesión de Powershell queramos utilizar los comandos de SQL,
#debemos importar el módulo SQLPS
Import-Module SQLPS –DisableNameChecking 

#Con PSDrive podemos ver las unidades de Poweshell. Vemos que ya tenemos como unidad el
#módulo SQLSERVER al que podemos acceder escribiendo cd sqlserver: 
PSDRIVE

#Dentro del directorio SQL vemos nuestra máquina y en Default entramos en nuestra instancia
#donde podemos acceder a todas sus características y objetos. Aquí encontramos el directorio
#Databases 
cd SQLSERVER:
cd sql
PS SQLSERVER:\sql>
cd DESKTOP-U2371TE


PS SQLSERVER:\sql\DESKTOP-U2371TE\default\databases> 