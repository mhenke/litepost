<cfsilent>
	<cfset content = event.getArg("content", "") />
	<cfset contentRight = event.getArg("contentRight", "") />
	<cfset isAdmin = event.getArg("isAdmin") />
</cfsilent>

<cfcontent reset="true" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>:: LitePost! ::</title>
	<link rel="stylesheet" type="text/css" href="views/css/simple.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>

<body>
	
	<div id="content">
	
	<div class="header">
		<h3>LitePost!</h3>
	</div>
	
	<cfoutput>
	
	<!-- center column -->
	<div class="center">
		<!-- content -->
		#content#
	</div>
	
	
	<!-- right columns -->
	<div class="right">
		#contentRight#
		
		<br/>
		<div class="links">
		<cfif isAdmin>
			<a href="index.cfm?#getProperty('eventParameter')#=logout">logout</a>
		<cfelse>
			<a href="index.cfm?#getProperty('eventParameter')#=showLogin">login</a>
		</cfif>
		</div>
	</div>
	
	</cfoutput>
	
	<div class="clearer">&#160;</div>
	
	<!-- copyright -->
	<p class="fine">&copy; 2006, Chris Scott, Matt Woodward, Adam Wayne Lehman, Dave Ross. All Rights Reserved.</p>
	
	</div>
	
</body>
</html>