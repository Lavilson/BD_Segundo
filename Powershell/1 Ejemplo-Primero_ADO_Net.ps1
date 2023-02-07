
#Listing 1: Retrieving Data Through a SqlDataReader Object


# Create SqlConnection object and define connection string
$con = New-Object System.Data.SqlClient.SqlConnection
$con.ConnectionString = "Server=.; Database=Pubs;   Integrated Security=true"
$con.open()

# Create SqlCommand object, define command text, and set the connection
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.CommandText = "SELECT TOP 10 au_fname, au_lname FROM dbo.authors"
$cmd.Connection = $con

# Create SqlDataReader
$dr = $cmd.ExecuteReader()

Write-Host

If ($dr.HasRows)
{
  Write-Host Number of fields: $dr.FieldCount
  Write-Host
  While ($dr.Read())
  {
    Write-Host $dr["au_fname"] $dr["au_lname"]
  }
}
Else
{
  Write-Host The DataReader contains no rows.
}

Write-Host

# Close the data reader and the connection
$dr.Close()
$con.Close()



############### AdventureWorks


#Listing 1: Retrieving Data Through a SqlDataReader Object


# Create SqlConnection object and define connection string
$con = New-Object System.Data.SqlClient.SqlConnection
$con.ConnectionString = "Server=.; Database=AdventureWorks2017;   Integrated Security=true"
$con.open()

# Create SqlCommand object, define command text, and set the connection
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.CommandText = "SELECT TOP 10 FirstName, LastName FROM Person.Person"
$cmd.Connection = $con

# Create SqlDataReader
$dr = $cmd.ExecuteReader()

Write-Host

If ($dr.HasRows)
{
  Write-Host Number of fields: $dr.FieldCount
  Write-Host
  While ($dr.Read())
  {
    Write-Host $dr["FirstName"] $dr["LastName"]
  }
}
Else
{
  Write-Host The DataReader contains no rows.
}

Write-Host

# Close the data reader and the connection
$dr.Close()
$con.Close()
