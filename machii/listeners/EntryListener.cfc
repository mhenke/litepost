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
		<cfargument name="bookmarkService" type="net.lightblog.component.entry.EntryService" required="true" />
		<cfset variables.entryService = arguments.entryService />
	</cffunction>
	
	<!--- listener methods --->
	<cffunction name="getEntriesForHomePage" returntype="array" access="public" output="false" 
			hint="Gets the entries for the home page using the numEntriesOnHomePage property in mach-ii.xml">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn variables.entryService.getEntries(getProperty("numEntriesOnHomePage")) />
	</cffunction>
	
	<cffunction name="getEntriesByCategoryID" returntype="array" access="public" output="false" 
			hint="Gets the entries for a particular category">
		<cfargument name="event" type="MachII.framework.Event" required="true" />
		
		<cfreturn variables.entryService.getEntriesByCategoryID(arguments.event.getArg("categoryID")) />
	</cffunction>
	
</cfcomponent>
