<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="userid")>
		<cfset property(name="fullName", sql="Concat(users.fname, ' ', users.lname)")>
		<cfset validatesPresenceOf(properties="fname,lname,email,username,password,role")>
		<cfset belongsTo("entry") >
	</cffunction>
</cfcomponent>