<!---
	Here you can add routes to your application and edit the default one.
	The default route is the one that will be called on your application's "home" page.
--->
<cfset addRoute(name="home", pattern="/blog/entry/[entryID]", controller="blog", action="entry")>
<cfset addRoute(name="home", pattern="/blog/index.cfm", controller="blog", action="main")>
<cfset addRoute(name="home", pattern="", controller="blog", action="main")>
