<!--- 
	  
  Copyright (c) 2006, Chris Scott, Matt Woodward, Adam Wayne Lehman, Dave Ross
  All rights reserved.
	
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  $Id: $

--->

<cfcomponent 
	displayname="EntryListener" 
	output="false" 
	extends="MachII.framework.Listener" 
	hint="The Entry listener for Lightblog">

	<cffunction name="configure" returntype="void" access="public" output="false" hint="Configures this listener; called automatically by Mach-II">
		<!--- don't need to do anything here --->
	</cffunction>
	
	<!--- setters for dependencies --->
	<cffunction name="setEntryService" returntype="void" access="public" output="false" hint="Dependency: EntryService">
		<cfargument name="entryService" type="net.litepost.component.entry.EntryService" required="true" />
		<cfset variables.entryService = arguments.entryService />
	</cffunction>
	
	<!--- listener methods --->
	<cffunction name="getEntry" returntype="net.litepost.component.entry.Entry" access="public" output="false" 
			hint="Returns an entry bean based on the entry ID in the event object">
		<cfargument name="event" type="MachII.framework.Event">
		
		<cfset var includeComments = true />
		
		<cfif arguments.event.isArgDefined("includeComments")>
			<cfset includeComments = arguments.event.getArg("includeComments") />
		</cfif>
		
		<cfreturn variables.entryService.getEntryByID(arguments.event.getArg("entryID"), includeComments) />
	</cffunction>
	
	<cffunction name="getEntries" returntype="array" access="public" output="false" 
			hint="Returns an array of entry objects and comment objects">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var numToReturn = -1 />
		<cfset var activeOnly = true />
		
		<cfif arguments.event.isArgDefined("numToReturn")>
			<cfset numToReturn = arguments.event.getArg("numToReturn") />
		</cfif>
		
		<cfif arguments.event.isArgDefined("activeOnly")>
			<cfset activeOnly = arguments.event.getArg("activeOnly") />
		</cfif>
		
		<cfreturn variables.entryService.getEntries(arguments.numToReturn, arguments.activeOnly) />
	</cffunction>
	
	<cffunction name="getEntriesAsQuery" returntype="query" access="public" output="false" 
			hint="Returns a query object of entry objects (does not include comments)">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var numToReturn = -1 />
		<cfset var activeOnly = true />
		
		<cfif arguments.event.isArgDefined("numToReturn")>
			<cfset numToReturn = arguments.event.getArg("numToReturn") />
		</cfif>
		
		<cfif arguments.event.isArgDefined("activeOnly")>
			<cfset activeOnly = arguments.event.getArg("activeOnly") />
		</cfif>
		
		<cfreturn variables.entryService.getEntriesAsQuery(arguments.numToReturn, arguments.activeOnly) />
	</cffunction>
	
	<cffunction name="getEntriesForHomePage" returntype="array" access="public" output="false" 
			hint="Gets the entries for the home page using the numEntriesOnHomePage property in mach-ii.xml">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn variables.entryService.getEntries(getProperty("numEntriesOnHomePage"), true) />
	</cffunction>
	
	<cffunction name="getEntriesByCategoryID" returntype="array" access="public" output="false" 
			hint="Gets the entries for a particular category">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var numToReturn = -1 />
		<cfset var activeOnly = true />
		
		<cfif arguments.event.isArgDefined("numToReturn")>
			<cfset numToReturn = arguments.event.getArg("numToReturn") />
		</cfif>
		
		<cfif arguments.event.isArgDefined("activeOnly")>
			<cfset activeOnly = arguments.event.getArg("activeOnly") />
		</cfif>
		
		<cfreturn variables.entryService.getEntriesByCategoryID(arguments.event.getArg("categoryID"), 
																numToReturn, activeOnly) />
	</cffunction>
	
	<cffunction name="processEntryForm" returntype="void" access="public" output="false" 
			hint="Processes the entry form and announces the next event">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var exitEvent = "showEntryForm" />
		
		<!--- if there's an exitEvent included in the event object, use it --->
		<cfif arguments.event.isArgDefined("exitEvent")>
			<cfset exitEvent = arguments.event.getArg("exitEvent") />
		</cfif>
		
		<!--- save the data --->
		<cfset variables.entryService.saveEntry(arguments.event.getArg("entry")) />
		
		<!--- announce the next event --->
		<cfset announceEvent(exitEvent, arguments.event.getArgs()) />
	</cffunction>
	
	<cffunction name="deleteEntry" returntype="void" access="public" output="false" 
			hint="Deletes an entry and announces the next event">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfset var exitEvent="showEntries" />

		<!--- if there's an exitEvent included in the event object, use it --->
		<cfif arguments.event.isArgDefined("exitEvent")>
			<cfset exitEvent = arguments.event.getArg("exitEvent") />
		</cfif>
		
		<!--- delete the entry --->
		<cfset variables.entryService.removeEvent(arguments.event.getArg("entryID")) />
		
		<!--- announce the next event --->
		<cfset announceEvent(exitEvent, arguments.event.getArgs()) />
	</cffunction>
</cfcomponent>
