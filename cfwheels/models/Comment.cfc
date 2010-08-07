<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="commentID")>
		<cfset validatesPresenceOf(properties="comment,name")>
		<cfset validatesFormatOf(property="url", type="url",allowBlank="true")>
		<cfset validatesFormatOf(property="email", type="email",allowBlank="true")>
		<cfset belongsTo("entry") >
	</cffunction>
</cfcomponent>