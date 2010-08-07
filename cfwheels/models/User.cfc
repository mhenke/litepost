<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="userid")>
		<cfset validatesPresenceOf(properties="id,fname,lname,email,username,password,role")>
	</cffunction>
</cfcomponent>