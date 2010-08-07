<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="categoryid")>
		<cfset property(name="categoriesCount", sql="(SELECT COUNT(*) FROM entries WHERE categories.categoryid = entries.categoryId)")> 
		<cfset validatesPresenceOf(properties="category")>
		<cfset belongsTo("entry") >
	</cffunction>
</cfcomponent>
