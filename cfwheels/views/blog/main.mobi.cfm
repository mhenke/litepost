<cfparam name="params.isAdmin" default="false" />
<cfparam name="framework.action" default="" />

<cfoutput>
	<cfif flashKeyExists("message")>
		<p style="color:red;font-weight:bold;" align="center">#flash("message")#</p>
	</cfif>
	<p style="color:red;font-weight:bold;" align="center">main.mobi.cfm</p>
	#includePartial("entries")#
</cfoutput>