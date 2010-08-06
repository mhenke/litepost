<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="categoryid")>
		<cfset property(name="categoriesCount", sql="(SELECT COUNT(*) FROM entries WHERE categories.categoryid = entries.categoryId)")> 
		<cfset validatesPresenceOf(properties="category")>
		<cfset belongsTo("Entry")>
		<cfset beforeDelete("checkEntries")>
	</cffunction>

	<cffunction name="checkEntries">
		<cfset var returnThis = true >
		<cfif IsQuery(model('entry').FindAllByCategoryid(this.id))>
			<cfset returnThis = false >
		</cfif>
		<cfreturn returnThis>
	</cffunction>
</cfcomponent>
