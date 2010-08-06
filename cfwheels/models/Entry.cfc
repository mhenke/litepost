<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="entryid")>
		<cfset property(name="commentCount", sql="(SELECT COUNT(*) FROM comments WHERE comments.entryid = entries.entryid)")> 
		<cfset validatesPresenceOf(properties="title,body")>
		<cfset hasMany("comment")>
		<cfset belongsTo("category")>
		<cfset beforeDelete("deleteAllComments")>
	</cffunction>
	
	<cffunction name="deleteAllComments" >
		<cfset model('category').deleteAll(this.categoryid)>
	</cffunction>
</cfcomponent>
