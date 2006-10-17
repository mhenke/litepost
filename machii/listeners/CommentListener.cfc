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

  $Id:  $

--->

<cfcomponent 
	displayname="CommentListener" 
	output="false" 
	extends="MachII.framework.Listener" 
	hint="The Comment listener for Lightblog">

	<cffunction name="configure" returntype="void" access="public" output="false" hint="Configures this listener; called automatically by Mach-II">
		<!--- don't need to do anything here --->
	</cffunction>
	
	<!--- setters for dependencies --->
	<cffunction name="setCommentService" returntype="void" access="public" output="false" hint="Dependency: CommentService">
		<cfargument name="commentService" type="net.litepost.component.comment.CommentService" required="true" />
		<cfset variables.commentService = arguments.commentService />
	</cffunction>

</cfcomponent>