<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="userid")>
		<cfset validatesPresenceOf(properties="fname,lname,email,username,password,role")>
	</cffunction>
</cfcomponent>