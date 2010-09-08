<!---
	If you leave these settings commented out, Wheels will set the data source name to the same name as the folder the application resides in.
	<cfset set(dataSourceName="")>
	<cfset set(dataSourceUserName="")>
	<cfset set(dataSourcePassword="")> 
--->

<!---
	If you leave this setting commented out, Wheels will try to determine the URL rewrite capabilities automatically.
	The URLRewriting setting can bet set to "On", "Partial" or "Off".
	To run with "Partial" rewriting, the "PATH_INFO" variable needs to be supported by the web server.
	To run with rewriting "On", you need to apply the necessary rewrite rules on the web server first.
	<cfset set(URLRewriting="Partial")>
--->
<cfset set(dataSourceName="litepost")>
<cfset set(timeStampOnCreateProperty = "dateCreated")>
<cfset set(timeStampOnUpdateProperty = "dateLastUpdated")>
<cfset set(overwritePlugins=false)>

<cfset loc.myapp = {}> 
<cfset loc.myapp.blogName = 'LitePost - CFWheels Edition' /> 
<cfset loc.myapp.blogURL = 'http://localhost/' /> 
<cfset loc.myapp.blogDescription = 'The CFWheels Edition of LitePost' /> 
<cfset loc.myapp.blogLanguage = 'en_US' /> 
<cfset loc.myapp.authorEmail = 'henke.mike@gmail.com' /> 
<cfset loc.myapp.webmasterEmail = 'henke.mike@gmail.com' />
<cfset loc.myapp.numEntries = 20 />
<cfset loc.myapp.generator = 'LitePost' />

<cfset set(myapp = loc.myapp)> 