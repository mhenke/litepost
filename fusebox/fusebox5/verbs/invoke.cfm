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
		// class - string default ""
		// object - string default ""
		// webservice - string default ""
		// one of class / object / webservice must be present
		if (not structKeyExists(fb_.verbInfo.attributes,"class")) {
			if (not structKeyExists(fb_.verbInfo.attributes,"object")) {
				if (not structKeyExists(fb_.verbInfo.attributes,"webservice")) {
					// error: class or object or webservice must be present
					fb_throw("fusebox.badGrammar.requiredAttributeMissing",
								"Required attribute is missing",
								"One of the attributes 'class', 'object' or 'webservice' is required, for a 'invoke' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
				} else {
					// webservice
				}
			} else {
				if (not structKeyExists(fb_.verbInfo.attributes,"webservice")) {
					// object
				} else {
					// error: only one of class or object or webservice may be present
					fb_throw("fusebox.badGrammar.requiredAttributeMissing",
								"Required attribute is missing",
								"One of the attributes 'class', 'object' or 'webservice' is required, for a 'invoke' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
				}
			}
		} else {
			if (structKeyExists(fb_.verbInfo.attributes,"object") or
						structKeyExists(fb_.verbInfo.attributes,"webservice")) {
					// error: only one of class or object or webservice may be present
					fb_throw("fusebox.badGrammar.requiredAttributeMissing",
								"Required attribute is missing",
								"One of the attributes 'class', 'object' or 'webservice' is required, for a 'invoke' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			} else {
				// class
			}
		}
		fb_.nAttrs = fb_.nAttrs + 1;	// for any one of class, object or webservice
		// methodcall - string default ""
		// method - string default "" (new in FB5)
		// one of methodcall or method must be present
		if (not structKeyExists(fb_.verbInfo.attributes,"methodcall")) {
			if (not structKeyExists(fb_.verbInfo.attributes,"method")) {
				fb_throw("fusebox.badGrammar.requiredAttributeMissing",
							"Required attribute is missing",
							"One of the attributes 'methodcall' or 'method' is required, for a 'invoke' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			} else {
				// method - prepare to gather up <argument> tags:
				fb_.verbInfo.data.arguments = "";
				fb_.verbInfo.data.separator = "";
			}
		} else {
			if (not structKeyExists(fb_.verbInfo.attributes,"method")) {
				// methodcall - FB41 compatible
				if (fb_.verbInfo.hasChildren) {
					fb_throw("fusebox.badGrammar.unexpectedChildren",
								"Unexpected child verbs",
								"The 'invoke' verb cannot have children when using the 'methodcall' attribute, in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
				}
			} else {
				// error: only one of methodcall or method may be present
				fb_throw("fusebox.badGrammar.requiredAttributeMissing",
							"Required attribute is missing",
							"One of the attributes 'methodcall' or 'method' is required, for a 'invoke' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			}
		}
		fb_.nAttrs = fb_.nAttrs + 1;	// for either one of methodcall or method
		// overwrite - boolean default true (if returnvariable is present)
		if (structKeyExists(fb_.verbInfo.attributes,"overwrite")) {
			if (listFind("true,false",fb_.verbInfo.attributes.overwrite) eq 0) {
				fb_throw("fusebox.badGrammar.invalidAttributeValue",
							"Attribute has invalid value",
							"The attribute 'overwrite' must either be ""true"" or ""false"", for a 'invoke' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			}
		} else {
			if (structKeyExists(fb_.verbInfo.attributes,"returnvariable")) {
				fb_.verbInfo.attributes.overwrite = true;
			} else {
				fb_.verbInfo.attributes.overwrite = false;
			}
		}
		fb_.nAttrs = fb_.nAttrs + 1;	// for overwrite - since we default it
		// returnvariable - string - required if overwrite is true
		if (not structKeyExists(fb_.verbInfo.attributes,"returnvariable")) {
			if (fb_.verbInfo.attributes.overwrite) {
				fb_throw("fusebox.badGrammar.requiredAttributeMissing",
							"Required attribute is missing",
							"The attribute 'returnvariable' is required if 'overwrite' is 'true', for a 'invoke' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			}
			// default to "" to make subsequent code easier
			fb_.verbInfo.attributes.returnvariable = "";
		}
		fb_.nAttrs = fb_.nAttrs + 1;	// for returnvariable - since we default it
		// strict mode - check attribute count:
		if (fb_.verbInfo.action.getCircuit().getApplication().strictMode) {
			if (structCount(fb_.verbInfo.attributes) neq fb_.nAttrs) {
				fb_throw("fusebox.badGrammar.unexpectedAttributes",
							"Unexpected attributes",
							"Unexpected attributes were found in a 'invoke' verb in fuseaction #fb_.verbInfo.circuit#.#fb_.verbInfo.fuseaction#.");
			}
		}
		
	} else {	// compile the code on the end tag:

		// check whether we're using the old-style methodcall or the new-style method / argument form:
		if (structKeyExists(fb_.verbInfo.attributes,"methodcall")) {
			fb_.methodcall = fb_.verbInfo.attributes.methodcall;
		} else {
			// complete the method call:
			fb_.methodcall = fb_.verbInfo.attributes.method & "(" & fb_.verbInfo.data.arguments & ")";
		}
		// compile <invoke>
		fb_.ret = fb_.verbInfo.attributes.returnvariable;
		if (structKeyExists(fb_.verbInfo.attributes,"object")) {
			// handled
			fb_.obj = fb_.verbInfo.attributes.object;
		} else if (structKeyExists(fb_.verbInfo.attributes,"class")) {
			// look it up
			fb_.classDef = fb_.verbInfo.action.getCircuit().getApplication().getClassDefinition(fb_.verbInfo.attributes.class);
			fb_.obj = 'createObject("#fb_.classDef.type#","#fb_.classDef.classpath#")';
		} else if (structKeyExists(fb_.verbInfo.attributes,"webservice")) {
			// this makes no sense but it's what the FB41 core files do:
			fb_.obj = fb_.verbInfo.attributes.webservice;
		}
		if (find("##",fb_.ret) gt 0) {
			fb_.ret = '"' & fb_.ret & '"';
		}
		if (fb_.verbInfo.attributes.overwrite) {
			fb_appendLine('<cfset #fb_.ret# = #fb_.obj#.#fb_.methodcall# >');
		} else {
			if (fb_.verbInfo.attributes.returnvariable is not "") {
				fb_appendLine('<cfif not isDefined("#fb_.verbInfo.attributes.returnvariable#")><cfset #fb_.ret# = #fb_.obj#.#fb_.methodcall# ></cfif>');
			} else {
				fb_appendLine('<cfset #fb_.obj#.#fb_.methodcall# >');
			}
		}
	}
</cfscript>
