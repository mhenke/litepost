
<!--- the main layout page --->

<cfsilent>
	<cfset content = ViewCollection.GetView("content") />
	<cfset contentRight = ViewCollection.GetView("contentRight") />
</cfsilent>
<cfcontent reset="true" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>:: LightBlog! ::</title>
	<link rel="stylesheet" type="text/css" href="views/css/simple.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>

<body>
	
	<div id="content">
	
	<div class="header">
		<h3>LightBlog!</h3>
	</div>
	
	<cfoutput>
	
	<!-- center column -->
	<div class="center">
		
		<!-- content -->
		<cfif len("content")>
			#content#
		</cfif>
			
	</div>
	
	
	<!-- right columns -->
	<div class="right">
		<cfif len("contentRight")>
			#contentRight#
		</cfif>
	</div>
	
	</cfoutput>
	
	<div class="clearer">&#160;</div>
	
	<!-- copyright -->
	<p class="fine">&copy; 2006, Chris Scott, Matt Woodward, Adam Wayne Lehman, Dave Ross. All Rights Reserved.</p>
	
	</div>
	
</body>
</html>