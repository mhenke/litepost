<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="categoryid")>
		<cfset property(name="categoriesCount", sql="(SELECT COUNT(*) FROM entries WHERE categories.categoryid = entries.categoryId)")> 
		<cfset validatesPresenceOf(properties="category")>
		<cfset hasMany("entry") >
		<cfset beforeDelete("checkEntries")>
	</cffunction>

	<cffunction name="checkEntries">
		<cfif IsQuery(model('entry').FindAllByCategoryId(this.id))>
			<cfset this.addErrorToBase(message="Your email address needs to be the same as your domain name.")>
		</cfif>
		<cfreturn false>
	</cffunction>
</cfcomponent>
