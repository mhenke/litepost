<cfsilent>
	<cfset entries = event.getArg("entries") />
	<cfset isAdmin = event.getArg("isAdmin") />
	<cfset fullDateString = "dddd, mmmm dd, yyyy" />
	<cfset shortDateString = "mmm dd, yyyy" />
	<cfset timeString = "h:mm tt" />
</cfsilent>

<!--- main entries page --->

<cfset lastDate = "" />
<cfoutput>
	<cfif arrayLen(entries) gt 0>
		<cfloop from="1" to="#ArrayLen(entries)#" index="i">
			<cfset entry = entries[i] />
			<cfset entryDate = entry.getEntryDate() />
			
			<cfif entryDate NEQ lastDate>
				<h4>#DateFormat(entryDate, fullDateString)#</h4>
				<cfset lastDate = entryDate />
			</cfif>
			
			<strong>#entry.getTitle()#</strong>
			<p>#entry.getBody()#</p>
			
			<div class="postlinks">
			posted #TimeFormat(entry.getDateCreated(), timeString)# | 
			<cfif entry.getDateLastUpdated() GT entry.getDateCreated() >updated #DateFormat(entry.getDateCreated(), shortDateString)# #TimeFormat(entry.getDateCreated(), timeString)# | </cfif>
			<cfif entry.getCategoryID() GT 0><a href="index.cfm?#getProperty('eventParameter')#=showHome&categoryID=#entry.getCategoryID()#">#entry.getCategory()#</a> | </cfif>
			<a href="index.cfm?#getProperty('eventParameter')#=comments&entryID=#entry.getEntryID()#">#entry.getNumComments()#  comments</a>
			<cfif isAdmin>
				&nbsp;|&nbsp;<a href="index.cfm?#getProperty('eventParameter')#=showEntryForm&entryID=#entry.getEntryID()#">edit</a>
			</cfif>
			</div>
			
			<br/>
			
		</cfloop>
	<cfelse>
		- no entries -
	</cfif>

</cfoutput>
