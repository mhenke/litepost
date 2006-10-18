<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: entry --->
<!--- fuseaction: entry --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "entry">
<cfset myFusebox.thisFuseaction = "entry">
<cfif NOT isDefined('ATTRIBUTES.entryID')>
<cfthrow message="Invalid Entry" detail="You must specify a valid entry.">
</cfif>
<cftry>
<cfoutput><cfinclude template="../home/entry/qry_getEntry.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 16 and right(cfcatch.MissingFileName,16) is "qry_getEntry.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse qry_getEntry.cfm in circuit entry which does not exist (from fuseaction entry.entry).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cftry>
<cfsavecontent variable="REQUEST.content.body"><cfoutput><cfinclude template="../home/entry/dsp_entries.cfm"></cfoutput></cfsavecontent>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 15 and right(cfcatch.MissingFileName,15) is "dsp_entries.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_entries.cfm in circuit entry which does not exist (from fuseaction entry.entry).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfcatch><cfrethrow></cfcatch>
</cftry>
<cfsetting enablecfoutputonly="false" />

