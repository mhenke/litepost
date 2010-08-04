<cfparam name="params.isAdmin" default="false" />
<cfparam name="framework.action" default="" />
<cfdump var="#params#">
<cfoutput>
#includePartial("entries")#
</cfoutput>