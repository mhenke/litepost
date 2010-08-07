<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="entryid")>
		<cfset property(name="commentCount", sql="(SELECT COUNT(*) FROM comments WHERE comments.entryid = entries.entryid)")> 
		<cfset validatesPresenceOf(properties=",userID,categoryIDbody,dateCreated,dateLastUpdated")>
		<cfset hasMany("comment")>
		<cfset belongsTo(name="category",joinType="OUTER")>
		<cfset belongsTo("user")>
		<cfset beforeDelete("deleteAllComments")>
	</cffunction>
	
	<cffunction name="deleteAllComments" >
		<cfset model('category').deleteAll(this.categoryid)>
	</cffunction>
</cfcomponent>
