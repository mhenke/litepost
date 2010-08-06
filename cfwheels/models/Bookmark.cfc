<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="bookmarkID")>
		<!---<cfset validatesPresenceOf(properties="title,body")>--->
	</cffunction>
</cfcomponent>
