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
<cfcomponent output="false" 
			hint="I compile a lexicon verb. I am created for each verb that needs to be compiled and I provide the thread-safe context in which that verb is compiled. That includes the various fb_* methods used to write to the parsed file.">

	<cffunction name="init" returntype="any" access="public" output="false" 
				hint="I am the constructor.">
		<cfargument name="writer" type="any" required="false" 
					hint="I am the parsed file writer object. I am required but it's faster to specify that I am not required." />
		<cfargument name="verbInfo" type="any" required="false" 
					hint="I am the verb compilation context. I am required but it's faster to specify that I am not required." />
		<cfargument name="lexiconInfo" type="any" required="false" 
					hint="I am the lexicon definition that supports this verb. I am required but it's faster to specify that I am not required." />
		
		<cfset variables.fb_writer = arguments.writer />
		<cfset variables.fb_ = structNew() />
		<cfset variables.fb_.verbInfo = arguments.verbInfo />
		<cfset variables.lexiconInfo = arguments.lexiconInfo />
		
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="compile" returntype="void" access="public" output="false" 
				hint="I compile a lexicon verb by including its implementation file.">

		<cfset var info = variables.lexiconInfo />
		<cfset var lexiconFile = info.lexicon.path />
		
		<cfset lexiconFile = lexiconFile & info.verb />
		<cfset lexiconFile = lexiconFile & "." & "cfm" />
		
		<cftry>
			<cfinclude template="#lexiconFile#" />
			<cfcatch type="missingInclude">
				<cfset fb_throw("fusebox.badGrammar.missingImplementationException",
								"Bad Grammar verb in circuit file",
								"The implementation file for the '#info.verb#' verb from the '#info.lexicon.namespace#'" &
									" custom lexicon could not be found.  It is used in the '#variables.fb_.verbInfo.circuit#.#variables.fb_.verbInfo.fuseaction#' fuseaction.") />
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="fb_appendLine" output="false" returntype="void" 
				hint="I append a line to the parsed file.">
		<cfargument name="lineContent" type="string" required="true" 
					hint="I am the line of text to append." />
		<cfset variables.fb_writer.println(arguments.lineContent) />
	</cffunction>
	
	<cffunction name="fb_appendIndent" output="false" returntype="void" 
				hint="I am a no-op provided for backward compatibility.">
	</cffunction>
	
	<cffunction name="fb_appendSegment" output="false" returntype="void" 
				hint="I append a segment of text to the parsed file.">
		<cfargument name="segmentContent" type="string" required="true" 
					hint="I am the segment of text to append." />
		<cfset variables.fb_writer.print(segmentContent) />
	</cffunction>
	
	<cffunction name="fb_appendNewline" output="false" returntype="void" 
				hint="I append a newline to the parsed file.">
		<cfset variables.fb_writer.println("") />
	</cffunction>
	
	<cffunction name="fb_increaseIndent" output="false" returntype="void" 
				hint="I am a no-op provided for backward compatibility.">
	</cffunction>
	
	<cffunction name="fb_decreaseIndent" output="false" returntype="void" 
				hint="I am a no-op provided for backward compatibility.">
	</cffunction>
	
	<cffunction name="fb_throw" output="false" returntype="void" 
				hint="I throw the specified exception.">
		<cfargument name="type" type="string" required="true" 
					hint="I am the type of exception to throw." />
		<cfargument name="message" type="string" required="true" 
					hint="I am the message to include in the thrown exception." />
		<cfargument name="detail" type="string" required="true" 
					hint="I am the detail to include in the thrown exception." />
		
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#" />

	</cffunction>
	
</cfcomponent>
