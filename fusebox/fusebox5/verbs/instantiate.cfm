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
<cfscript>
	if (fb_.verbInfo.executionMode is "start") {
		// validate attributes
		fb_.nAttrs = 0;
		// arguments - string default ""
		if (not structKeyExists(fb_.verbInfo.attributes,"arguments")) {
			// prepare to gather up <argument> tags, if any:
			fb_.verbInfo.data.arguments = "";
			fb_.verbInfo.data.separator = "";
		} else {
			fb_.nAttrs = fb_.nAttrs + 1;	// for arguments - since we do not default it
			if (fb_.verbInfo.hasChildren) {
				fb_throw("fusebox.badGrammar.unexpectedChildren",
							"Unexpected child verbs",
							"The 'instantiate' verb cannot have children when using the 'arguments' attribute, in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			}
		}
		// class - string default ""
		// webservice - string default ""
		// one of class or webservice must be present
		if (not structKeyExists(fb_.verbInfo.attributes,"class")) {
			if (not structKeyExists(fb_.verbInfo.attributes,"webservice")) {
				// error: class or webservice must be present
				fb_throw("fusebox.badGrammar.requiredAttributeMissing",
							"Required attribute is missing",
							"Either the attribute 'class' or 'webservice' is required, for a 'instantiate' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			} else {
				// webservice
			}
		} else {
			if (not structKeyExists(fb_.verbInfo.attributes,"webservice")) {
				// class
			} else {
				// error: only one of class or webservice may be present
				fb_throw("fusebox.badGrammar.requiredAttributeMissing",
							"Required attribute is missing",
							"Either the attribute 'class' or 'webservice' is required, for a 'instantiate' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			}
		}
		fb_.nAttrs = fb_.nAttrs + 1;	// for either one of class or webservice
		// object - string - required
		if (not structKeyExists(fb_.verbInfo.attributes,"object")) {
			fb_throw("fusebox.badGrammar.requiredAttributeMissing",
						"Required attribute is missing",
						"The attribute 'object' is required, for a 'instantiate' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
		}
		fb_.nAttrs = fb_.nAttrs + 1;	// for object
		// overwrite - boolean default true
		if (structKeyExists(fb_.verbInfo.attributes,"overwrite")) {
			if (listFind("true,false",fb_.verbInfo.attributes.overwrite) eq 0) {
				fb_throw("fusebox.badGrammar.invalidAttributeValue",
							"Attribute has invalid value",
							"The attribute 'overwrite' must either be ""true"" or ""false"", for a 'instantiate' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			}
		} else {
			fb_.verbInfo.attributes.overwrite = true;
		}
		fb_.nAttrs = fb_.nAttrs + 1;	// for overwrite - since we default it
		// strict mode - check attribute count:
		if (fb_.verbInfo.action.getCircuit().getApplication().strictMode) {
			if (structCount(fb_.verbInfo.attributes) neq fb_.nAttrs) {
				fb_throw("fusebox.badGrammar.unexpectedAttributes",
							"Unexpected attributes",
							"Unexpected attributes were found in a 'instantiate' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			}
		}
	
	} else {
		
		// update arguments if we had any child <argument> tags:
		if (structKeyExists(fb_.verbInfo.attributes,"arguments")) {
			fb_.args = fb_.verbInfo.attributes.arguments;
		} else {
			fb_.args = fb_.verbInfo.data.arguments;
		}

		// compile <instantiate>
		fb_.obj = fb_.verbInfo.attributes.object;
		fb_.constructor = "";
		if (find("##",fb_.obj) gt 0) {
			fb_.obj = '"' & fb_.obj & '"';
		}
		if (structKeyExists(fb_.verbInfo.attributes,"class")) {
			// look up the class definition:
			fb_.classDef = fb_.verbInfo.action.getCircuit().getApplication().getClassDefinition(fb_.verbInfo.attributes.class);
			fb_.creation = 'createObject("#fb_.classDef.type#","#fb_.classDef.classpath#")';
			fb_.constructor = fb_.classDef.constructor;
		} else {
			fb_.creation = 'createObject("webservice","#fb_.verbInfo.attributes.webservice#")';
		}
		// I'd rather the constructor was called immediately on construction but it can't be guaranteed that the constructor returns this
		if (fb_.verbInfo.attributes.overwrite) {
			fb_appendLine('<cfset #fb_.obj# = #fb_.creation# >');
			if (fb_.constructor is not "") {
				fb_appendLine('<cfset #fb_.obj#.#fb_.constructor#(#fb_.args#) >');
			} else if (fb_.args is not "") {
				fb_throw("fusebox.badGrammar.invalidAttributeValue",
							"Attribute has invalid value",
							"Arguments may not be specified when there is no constructor specified for the class.");
			}
		} else {
			fb_appendLine('<cfif not isDefined("#fb_.verbInfo.attributes.object#")>');
			fb_appendLine('<cfset #fb_.obj# = #fb_.creation# >');
			if (fb_.constructor is not "") {
				fb_appendLine('<cfset #fb_.obj#.#fb_.constructor#(#fb_.args#) >');
			} else if (fb_.args is not "") {
				fb_throw("fusebox.badGrammar.invalidAttributeValue",
							"Attribute has invalid value",
							"Arguments may not be specified when there is no constructor specified for the class.");
			}
			fb_appendLine('</cfif>');
		}
	}
</cfscript>
