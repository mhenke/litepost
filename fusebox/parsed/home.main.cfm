<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: home --->
<!--- fuseaction: main --->
<cftry>
<!--- do action="entry.recent" --->
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "entry">
<cfset myFusebox.thisFuseaction = "recent">
<cftry>
<cfoutput><cfinclude template="../home/entry/qry_getEntries.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 18 and right(cfcatch.MissingFileName,18) is "qry_getEntries.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse qry_getEntries.cfm in circuit entry which does not exist (from fuseaction entry.recent).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfsavecontent variable="REQUEST.content.body"><cfoutput><cfinclude template="../home/entry/dsp_entries.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 15 and right(cfcatch.MissingFileName,15) is "dsp_entries.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_entries.cfm in circuit entry which does not exist (from fuseaction entry.recent).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfset myFusebox.thisCircuit = "home">
<cfset myFusebox.thisFuseaction = "main">
<cftry>
<cfoutput><cfinclude template="../home/../layout/lay_main.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 22 and right(cfcatch.MissingFileName,22) is "../layout/lay_main.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse ../layout/lay_main.cfm in circuit home which does not exist (from fuseaction home.$postfuseaction).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>
<cfsetting enablecfoutputonly="false" />

