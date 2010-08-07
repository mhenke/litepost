<cfcomponent extends="Model" output="false">
	<cffunction name="init">
		<cfset property(name="id", column="bookmarkID")>
		<cfset validatesPresenceOf(properties="id,name,url")>
		<cfset validatesFormatOf(property="url", type="url",allowBlank="true")>
	</cffunction>
</cfcomponent>
