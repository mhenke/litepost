<cfparam name="params.isAdmin" default="false" />
<cfparam name="framework.action" default="" />

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfparam name="params.title" default="LitePost Blog" />
	<title><cfoutput>#params.title#</cfoutput></title>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1">

	#styleSheetLinkTag("lp_layout,lp_text,lp_forms")#

</head>

<body>

<!-- display divider-->
<div id="bar">&nbsp;</div>

<cfoutput>
<!-- main container -->
<div id="container">

	<!-- login/out button -->
	<cfif params.isAdmin>
		#linkTo(text="Log Out", controller="blog", action="logout", id="loginbutton", class="adminbutton")#
	<cfelse>
		#linkTo(text="Log In", controller="blog", action="login", id="loginbutton", class="adminbutton")#
	</cfif>
	
	<!-- header block -->
	<div id="header">
		#linkTo(text="#imageTag(source="litePost_logo.gif", border="0", title="litePost")#", controller="blog", action="main")#
	</div>
	
	<!-- wrapper block to constrain widths -->
	<div id="wrapper">
		<!-- begin body content -->
		<div id="content">
			<!-- anchor to top of content, also used for skip to content links-->
			<a name="content"></a>
			
			<!-- content -->
			#contentForLayout()#
	  	</div>
		
	</div>
	<!-- navigation -->
	<div id="navigation">
		
		#includePartial("navigation")#
		
	</div>
	
	<!-- site footer-->
	<div id="footer"><p>LitePost is made under the Creative Commons license! (or something like that)</p></div>
	
</div>
</cfoutput>

</body>
</html>
</cfoutput>
