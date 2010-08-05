<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="commentid")>
		<cfset belongsTo("entry")>
	</cffunction>
</cfcomponent>
