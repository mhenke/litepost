<html>
	<head>
		<title>Litepost Home</title>
	</head>
	<body>
	<cfoutput>
		<h3>Litepost Home</h3>
		
		<p>This is the Litepost home page.</p>
		
		<cfdump var="#event.getArg('entries')#" />
		
		<ul>
			<li><a href="index.cfm?#getProperty('eventParameter')#=showLogin">Login</a></li>
		</ul>
	</cfoutput>
	</body>
</html>