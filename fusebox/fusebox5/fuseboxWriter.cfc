<!---
Fusebox Software License
Version 1.0

Copyright (c) 2003, 2004, 2005, 2006 The Fusebox Corporation. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted 
provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions 
   and the following disclaimer.

2. Redistributions in binary form or otherwise encrypted form must reproduce the above copyright 
   notice, this list of conditions and the following disclaimer in the documentation and/or other 
   materials provided with the distribution.

3. The end-user documentation included with the redistribution, if any, must include the following 
   acknowledgment:

   "This product includes software developed by the Fusebox Corporation (http://www.fusebox.org/)."

   Alternately, this acknowledgment may appear in the software itself, if and wherever such 
   third-party acknowledgments normally appear.

4. The names "Fusebox" and "Fusebox Corporation" must not be used to endorse or promote products 
   derived from this software without prior written (non-electronic) permission. For written 
   permission, please contact fusebox@fusebox.org.

5. Products derived from this software may not be called "Fusebox", nor may "Fusebox" appear in 
   their name, without prior written (non-electronic) permission of the Fusebox Corporation. For 
   written permission, please contact fusebox@fusebox.org.

If one or more of the above conditions are violated, then this license is immediately revoked and 
can be re-instated only upon prior written authorization of the Fusebox Corporation.

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE FUSEBOX CORPORATION OR ITS CONTRIBUTORS BE LIABLE FOR ANY 
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-------------------------------------------------------------------------------

This software consists of voluntary contributions made by many individuals on behalf of the 
Fusebox Corporation. For more information on Fusebox, please see <http://www.fusebox.org/>.

--->
<cfcomponent output="false" hint="I manage the creation of and writing to the parsed files.">

	<cffunction name="init" returntype="any" access="public" output="false" 
				hint="I am the constructor.">
		<cfargument name="fbApp" type="any" required="false" 
					hint="I am the fusebox application object. I am required but it's faster to specify that I am not required." />
		<cfargument name="myFusebox" type="any" required="false" 
					hint="I am the myFusebox data structure. I am required but it's faster to specify that I am not required." />
		
		<cfset variables.fuseboxApplication = arguments.fbApp />
		<cfset variables.myFusebox = arguments.myFusebox />
		<cfset variables.parsedDir = variables.fuseboxApplication.getApplicationRoot() & variables.fuseboxApplication.parsePath />
		<cfset variables.phase = "" />
		<cfset variables.circuit = "" />
		<cfset variables.fuseaction = "" />
		<cfset variables.newline = chr(13) & chr(10) />
		
		<cfif not directoryExists(variables.parsedDir)>
			<cflock name="#variables.parsedDir#" type="exclusive" timeout="30">
				<cfif not directoryExists(variables.parsedDir)>
					<cftry>
						<cfdirectory action="create" directory="#variables.parsedDir#" mode="777" />
					<cfcatch type="any">
						<cfthrow type="fusebox.missingParsedDirException"
							message="The 'parsed' directory in the application root directory is missing, and could not be created"
							detail="You must manually create this directory, and ensure that CF has the ability to write and change files within the directory."
							extendedinfo="#cfcatch.detail#" />
					</cfcatch>
					</cftry>
				</cfif>
			</cflock>
		</cfif>

		<cfset reset() />

		<cfreturn this />

	</cffunction>
	
	<cffunction name="getMyFusebox" returntype="any" access="public" output="false">
	
		<cfreturn variables.myFusebox />
		
	</cffunction>

	<cffunction name="reset" returntype="void" access="public" output="false" 
				hint="I reset the phase, circuit and fuseaction as well as initializing the file content object.">

		<cfset variables.lastPhase = "" />
		<cfset variables.lastCircuit = "" />
		<cfset variables.lastFuseaction = "" />
		<cfset variables.content = createObject("java","java.lang.StringBuffer").init() />

	</cffunction>	

	<cffunction name="open" returntype="void" access="public" output="false" 
				hint="I 'open' the parsed file. In fact I just setup the writing process. The file is only created when this writer object is 'closed'.">
		<cfargument name="filename" type="string" required="true" 
					hint="I am the name of the parsed file to be created." />
		
		<cfset variables.filename = arguments.filename />
		<cfset reset() />
		<cfset rawPrintln('<cfsetting enablecfoutputonly="true" />') />
		<cfset rawPrintln('<cfprocessingdirective pageencoding="#variables.fuseboxApplication.characterEncoding#" />') />
		
	</cffunction>
	
	<cffunction name="close" returntype="void" access="public" output="false" 
				hint="I 'close' the parsed file and write it to disk.">
		
		<cfset rawPrintln('<cfsetting enablecfoutputonly="false" />') />
		<cftry>
			<cffile action="write" file="#variables.parsedDir#/#variables.filename#"
					output="#variables.content.toString()#"
					charset="#variables.fuseboxApplication.characterEncoding#" />
		<cfcatch type="any">
			<cfthrow type="fusebox.errorWritingParsedFile" 
					message="An Error during write of Parsed File or Parsing Directory not found." 
					detail="Attempting to write the parsed file '#variables.filename#' threw an error. This can also occur if the parsed file directory cannot be found."
					extendedinfo="#cfcatch.detail#" />
		</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="setPhase" returntype="any" access="public" output="false" 
				hint="I remember the currently executing plugin phase.">
		<cfargument name="phase" type="any" required="false" 
					hint="I am the name of the current phase. I am required but it's faster to specify that I am not required." />
		
		<cfset var p = variables.phase />
		
		<cfset variables.phase = arguments.phase />
		
		<cfreturn p />
		
	</cffunction>
	
	<cffunction name="setCircuit" returntype="any" access="public" output="false" 
				hint="I remember the currently executing circuit alias.">
		<cfargument name="circuit" type="any" required="false" 
					hint="I am the name of the current circuit. I am required but it's faster to specify that I am not required." />
		
		<cfset var c = variables.circuit />
		
		<cfset variables.circuit = arguments.circuit />
		
		<cfreturn c />
		
	</cffunction>
	
	<cffunction name="setFuseaction" returntype="any" access="public" output="false" 
				hint="I remember the currently executing fuseaction name.">
		<cfargument name="fuseaction" type="any" required="false" 
					hint="I am the name of the current fuseaction. I am required but it's faster to specify that I am not required." />
		
		<cfset var f = variables.fuseaction />
		
		<cfset variables.fuseaction = arguments.fuseaction />
		
		<cfreturn f />
		
	</cffunction>
	
	<cffunction name="print" returntype="void" access="public" output="false" 
				hint="I print a string to the parsed file. I set the phase, circuit and fuseaction variables if necessary in the myFusebox structure.">
		<cfargument name="text" type="any" required="false" 
					hint="I am the string to be printed. I am required but it's faster to specify that I am not required." />
		
		<cfif variables.lastPhase is not variables.phase>
			<cfset rawPrintln('<cfset myFusebox.thisPhase = "#variables.phase#">') />
			<cfset variables.lastPhase = variables.phase />
		</cfif>
		<cfif variables.lastCircuit is not variables.circuit>
			<cfset rawPrintln('<cfset myFusebox.thisCircuit = "#variables.circuit#">') />
			<cfset variables.lastCircuit = variables.circuit />
		</cfif>
		<cfif variables.lastFuseaction is not variables.fuseaction>
			<cfset rawPrintln('<cfset myFusebox.thisFuseaction = "#variables.fuseaction#">') />
			<cfset variables.lastFuseaction = variables.fuseaction />
		</cfif>
		<cfset variables.content.append(arguments.text) />
		
	</cffunction>
	
	<cffunction name="println" returntype="void" access="public" output="false" 
				hint="I print a string to the parsed file, followed by a newline. I set the phase, circuit and fuseaction variables if necessary in the myFusebox structure.">
		<cfargument name="text" type="any" required="false" 
					hint="I am the string to be printed. I am required but it's faster to specify that I am not required." />
		
		<cfset print(arguments.text) />
		<cfset variables.content.append(variables.newline) />
		
	</cffunction>
	
	<cffunction name="rawPrint" returntype="void" access="public" output="false" 
				hint="I print a string to the parsed file, without setting any variables.">
		<cfargument name="text" type="any" required="false" 
					hint="I am the string to be printed. I am required but it's faster to specify that I am not required." />

		<cfset variables.content.append(arguments.text) />

	</cffunction>
	
	<cffunction name="rawPrintln" returntype="void" access="public" output="false" 
				hint="I print a string to the parsed file, followed by a newline, without setting any variables.">
		<cfargument name="text" type="any" required="false" 
					hint="I am the string to be printed. I am required but it's faster to specify that I am not required." />

		<cfset variables.content.append(arguments.text).append(variables.newline) />

	</cffunction>
		
</cfcomponent>