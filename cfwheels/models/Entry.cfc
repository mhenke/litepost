<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="entryid")>
		<cfset validatesPresenceOf(properties="title,body")>
		<cfset hasMany("comments")>
	</cffunction>
</cfcomponent>
