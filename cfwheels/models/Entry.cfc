<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="entryid")>
		<cfset property(name="commentCount", sql="(SELECT COUNT(*) FROM comments WHERE comments.entryid = entries.entryid)")> 
		<cfset validatesPresenceOf(properties="id,userid,categoryid,body,dateCreated,dateLastUpdated")>
		<cfset hasMany("comments")>
		<cfset belongsTo(name="category",joinType="OUTER")>
		<cfset belongsTo("user")>
	</cffunction>
</cfcomponent>