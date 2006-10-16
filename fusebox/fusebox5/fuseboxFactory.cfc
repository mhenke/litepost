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
<cfcomponent output="false" hint="I am a factory object that creates verb objects.">

	<cffunction name="init" returntype="fuseboxFactory" access="public" output="false" 
				hint="I am the constructor.">
		
		<cfset variables.lexCompPool = 0 />
		<cfset variables.verbLexPool = 0 />
		
		<cfset variables.fuseboxLexicon = structNew()/>
		<cfset variables.fuseboxLexicon.namespace = "$fusebox" />
		<cfset variables.fuseboxLexicon.path = "verbs/" />
		
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="create" returntype="any" access="public" output="false" 
				hint="I create a verb object.">
		<cfargument name="verb" type="string" required="true" 
					hint="I am the name of the verb to create." />
		<cfargument name="action" type="any" required="true" 
					hint="I am the enclosing fuseaction object." />
		<cfargument name="attributes" type="struct" required="true" 
					hint="I am the attributes of this verb." />
		<cfargument name="children" type="any" required="true" 
					hint="I am the XML representation of this verb's children." />
		<cfargument name="global" type="boolean" default="false" 
					hint="I indicate whether this is part of a regular fuseaction (false) or a global fuseaction (true)." />
		
		<cfset var verbObject = "" />
		
		<!--- global pre/post process is a special case: --->
		<cfif arguments.global>
			<cfif listFind("do,fuseaction",arguments.verb)>
				<!--- this is OK, do is deprecated --->
				<cfif arguments.verb is "do" and arguments.action.getCircuit().getApplication().strictMode>
					<cfthrow type="fusebox.badGrammar.deprecated" 
							message="Deprecated feature"
							detail="Using the 'do' verb in a global pre/post process was deprecated in Fusebox 4.1." />
				</cfif>
			<cfelse>
				<!--- no other verbs are allowed --->
				<cfthrow type="fusebox.badGrammar.illegalVerb"
						message="Illegal verb encountered" 
						detail="The '#arguments.verb#' verb is illegal in a global pre/post process." />
			</cfif>
		<cfelse>
			<cfif listFind("fuseaction",arguments.verb)>
				<!--- verbs that are only legal in global pre/post process --->
				<cfthrow type="fusebox.badGrammar.illegalVerb"
						message="Illegal verb encountered" 
						detail="The '#arguments.verb#' verb is only legal in a global pre/post process." />
			</cfif>
		</cfif>
		<cfif listLen(arguments.verb,".:") eq 2>
			<!--- must be namespace.verb or namespace:verb --->
			<cfset verbObject = createObject("component","fuseboxVerb")
					.init(arguments.action, arguments.verb, arguments.attributes, arguments.children) />
		<cfelseif listFind("do,fuseaction",arguments.verb)>
			<!--- built-in verbs that cannot be implemented as a lexicon --->
			<cfset verbObject = createObject("component","fuseboxDoFuseaction")
					.init(arguments.action,arguments.attributes,arguments.children,arguments.verb) />
		<cfelse>
			<!--- builtin verb implemented as a lexicon --->
			<cfset verbObject = createObject("component","fuseboxVerb")
					.init(arguments.action, variables.fuseboxLexicon.namespace & ":" & arguments.verb,
							arguments.attributes, arguments.children) />
		</cfif>
		<cfreturn verbObject />
		
	</cffunction>
	
	<cffunction name="createLexiconCompiler" returntype="any" access="public" output="false" 
				hint="I return a lexicon compiler context (either from the pool or a newly created instance).">
	
		<cfset var obj = 0 />
		
		<cfif isSimpleValue(variables.lexCompPool)>
			<cfset obj = createObject("component","fuseboxLexiconCompiler") />
		<cfelse>
			<cfset obj = variables.lexCompPool />
			<cfset variables.lexCompPool = obj._next />
		</cfif>
		
		<cfreturn obj />
	
	</cffunction>
	
	<cffunction name="freeLexiconCompiler" returntype="void" access="public" output="false" 
				hint="I return the lexicon compiler context to the pool.">
		<cfargument name="lexComp" type="any" required="false"
					hint="I am the lexicon compiler context to be returned. I am required but it's faster to specify that I am not required." />
	
		<cfset arguments.lexComp._next = variables.lexCompPool />
		<cfset variables.lexCompPool = arguments.lexComp />
		
	</cffunction>
	
	<cffunction name="getBuiltinLexicon" returntype="any" access="public" output="false" 
				hint="I return the (magic) builtin lexicon.">
		
		<cfreturn variables.fuseboxLexicon />
		
	</cffunction>
	
</cfcomponent>
