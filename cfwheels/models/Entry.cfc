<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="entryid")>
		 <cfset hasMany("comments")>
	</cffunction>
</cfcomponent>
