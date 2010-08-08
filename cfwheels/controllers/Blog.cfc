<cfcomponent extends="Controller" output="false">

<cfscript>
	
	// init
	function init() {
		
		filters(through="setSecurityService,before");
		filters(through="setSessionService",only="saveEntry");
		filters(through="setRssService",only="rss");
		filters(through="setUserService",only="doLogin");
		filters(through="setupForEntry",only="entry,savecomment,comments");
		
	}
	
	// called before any actions:
	function before() {	
	
	 	isAdmin = variables.securityService.isAuthenticated();
	 	bookmarks = model("bookmark").findAll();
		categories = model("category").findAll();

	 }
	 
	 // called entry, savecomment, and comments:
	 function setupForEntry() {

	 	fullDateString = "dddd, mmmm dd, yyyy";
		shortDateString = "mmm dd, yyyy";
		timeString = "h:mm tt";
		
	 }
	
	// blog actions:
	
	// bookmark - add/edit bookmark:
	function bookmark() {
		
		var id = 0;
		
		if ( structKeyExists( params, "key" ) ) {
			id = val( params.key );
		}

		label = "Update";
		bookmark = model("bookmark").FindByKey( id );
		
		if (not IsObject(bookmark)) {
			label = "Create";
    		bookmark = model("bookmark").new();
		}

		title = "LitePost Blog - #label# Link";
		
	}
	
	// category - add/edit category:
	function category() {
		
		var id = 0;
		
		if ( structKeyExists( params, "key" ) ) {
			id = val( params.key );
		}

		label = "Update";
		category = model("category").FindByKey( id );
		
		if (not IsObject(category)) {
			label = "Create";
    		category = model("category").new();
		}

		title = "LitePost Blog - #label# Category";
		
	}
	
	// comments - show entry with comments:
	function comments() {
		
		var id = 0;
		
		if ( structKeyExists( params, "entryID" ) ) {
			id = val( params.entryID );
		}
		entry = model("entry").FindByKey(id);
		if ( structKeyExists( params, "comment") ) {
			return;
		}
		
		entry = model("entry").findByKey( key=id, include="category,comments,user", returnAs="query" );
		
		if (not structKeyExists( variables, "comment")) {
		comment = model("comment").new(name="", url="",comment="",email="");
		}
		
		comments = model("comment").findAllByEntryID(id);

	}
	
	// deleteBookmark - delete by ID
	function deleteBookmark() {

		var id = 0;
		
		if ( structKeyExists( params, "key" ) ) {
			id = val( params.key);
		}
		model("bookmark").deleteByKey(id);
		redirectTo(action="main");

	}
	
	// deleteCategory - delete by ID
	function deleteCategory() {

		var id = 0;
		
		if ( structKeyExists( params, "key" ) ) {
			id = val( params.key);
		}
		
		entries = model("entry").findAllByCategoryId(id);
		
		if (entries.recordCount GT 0) {
			flashInsert(message="This category cannot be deleted. It has  #pluralize(word="entry", count=entries.recordCount)# filed under it.");
			redirectTo(action="main",params="categoryId=#id#");
		} else {
			category = model("category").DeleteByKey(id);
			redirectTo(action="main");
		}
		
	}
	
	// deleteEntry - delete by ID
	function deleteEntry() {
		
		var id = 0;
		
		if ( structKeyExists( params, "key" ) ) {
			id = val( key );
		}

		aEntry = model("entry").findByKey( id );
      	aEntry.deleteAllComments();
      	aEntry.delete();
		
		entries = model("entry").findAll();
		redirectTo(action="main");
		
	}
	
	// doLogin - attempt authentication:
	function doLogin() {
		
		var user = variables.userService.authenticate( params.username, params.password );
		
		if ( user.isNull() ) {
			flashInsert(message="User not found!");
			redirectTo( action="login" );
		} else {
			redirectTo( action="main" );
		}
		
	}
	
	// entry - add/edit entry:
	function entry() {

		var id = 0;
		
		if ( structKeyExists( params, "entryID" ) ) {
			id = val( params.entryID );
		}
		
		if ( id == 0 ) {
			entry = model("entry").new();
			label = "Add";
		} else {
			entry = model("entry").FindByKey(id);
			label = "Update";
		}
		
		title = "LitePost Blog - #label# Entry";
		
	}
	
	// logout - end user session:
	function logout() {
		
		securityService.removeUserSession();
		redirectTo( action="main" );

	}
	
	// main - home page:
	function main() {
		
		if ( structKeyExists( params, "categoryID" ) and val( params.categoryID ) ) {
			entries = model("entry").findAllByCategoryID(include="category,user", order="dateCreated DESC", where="dateCreated <= '#now()#'", select="id,title,fullname,datelastupdated,body,commentcount,categoryid,category", value=categoryID);
		} else {
			entries = model("entry").findAll(include="category,user", order="dateCreated DESC", where="dateCreated <= '#now()#'", select="id,title,fullname,datelastupdated,body,commentcount,categoryid,category");
		}

	}
	
	function rss() {
		
		var args = structCopy( variables.fw.getBlogConfiguration() );
			
		// additional arguments used in RSSService:
		args.eventParameter = variables.fw.getAction();
		args.eventLocation = "blog.comments";
		args.generator = "LitePost";
		
		// fixup blogLanguage:
		args.blogLanguage = replace(lcase(args.blogLanguage), "_", "-", "one");
		
		if ( structKeyExists( params, "categoryID" ) ) {
			args.categoryId = params.categoryId;
			args.categoryName = params.categoryName;
			
			rss = variables.rssService.getCategoryRSS( argumentCollection=args );
			
			// <cfset rss = variables.rssService.getCategoryRSS(categoryID, 
			//										"Category: " & categoryID,  
			//										blogName, 
			//										blogURL, 
			//										blogDescription, 
			//										replace(lcase(blogLanguage), "_", "-", "one"), 
			//										"LitePost", 
			//										authorEmail, 
			//										webmasterEmail, 
			//										eventValue) />
													
		} else {
			rss = variables.rssService.getBlogRSS( argumentCollection=args );
			
			// <cfset rss = variables.rssService.getBlogRSS(numEntriesOnHomePage, 
			//										blogName, 
			//										blogURL, 
			//										blogDescription, 
			//										replace(lcase(blogLanguage), "_", "-", "one"), 
			//										"LitePost", 
			//										authorEmail, 
			//										webmasterEmail, 
			//										eventValue) />
		}
		
	}

	// saveBookmark - create/update bookmark:
	function saveBookmark() {

		var returnValue = "";
		
		if ( structKeyExists( params.bookmark, "id" ) and val(params.bookmark.id)) {
  			bookmark = model("bookmark").findByKey(params.bookmark.id); 
			returnValue = bookmark.update(params.bookmark);
			label = "Update";
		}
		else 
		{ 
  			bookmark = model("bookmark").new(params.bookmark);
			returnValue = bookmark.save();
			label = "Create";
		} 
		
		title = "LitePost Blog - #label# Link";

		if (returnValue) {
    		redirectTo(action="main");
		} else {
    		flashInsert(message="Please complete the bookmark form!");
    		renderPage(action="bookmark");
		}
		
	}

	// saveCategory - create/update category:
	function saveCategory() {

	    var returnValue = "";
		
		if ( structKeyExists( params.category, "id" ) and val(params.category.id)) {
  			category = model("category").findByKey(params.category.id); 
			returnValue = category.update(params.category);
			label = "Update";
		}
		else 
		{ 
  			category = model("category").new(params.category);
			returnValue = category.save();
			label = "Update";
		} 
		
		title = "LitePost Blog - #label# Category";

		if (returnValue) {
    		redirectTo(action="main");
		} else {
    		flashInsert(message="Please complete the category form!");
    		renderPage(action="category");
		}
		
	}

	// saveComment - create/update comment:
	function saveComment() {

  		comment = model("comment").create(params.comment);
		entry = model("entry").findByKey(key=params.comment.entryid, include="category,comments,user",returnAs="query");
		comments = model("comment").findAllByEntryID(params.comment.entryid);
		
		if (comment.hasErrors()) {
    		flashInsert(message="Please complete the comment form!");
			renderPage(action="comments",params="entryID=#params.comment.entryid#");
		}
		// Why does it always redirect even if hasErrors()
		redirectTo(action="comments",params="entryID=#params.comment.entryid#");

	}

	// saveEntry - create/update entry:
	function saveEntry() {
		
	   var returnValue = "";
	   entry = false;
	   
	   params.entry.userid = variables.sessionService.getUser().getUserId();
	   params.entry.dateLastUpdated = now();
	   
	   if ( structKeyExists( params.entry, "categoryid" ) and not val(params.entry.categoryid)) {
	   		params.entry.categoryid = 0;
	   }
		
		if ( structKeyExists( params.entry, "id" ) and val(params.entry.id)) {
  			entry = model("entry").findByKey(params.entry.id); 
		}
		
		if ( isObject(entry)) {
			returnValue = entry.update(params.entry);
			label = "Update";
		} else { 
  			entry = model("entry").new(params.entry);
			returnValue = entry.save();
			label = "Add";
		 }
		
		title = "LitePost Blog - #label# entry";

		if (returnValue) {
    		redirectTo(action="main");
		} else {
    		flashInsert(message="Please complete the entry form!");
    		renderPage(action="entry");
		}

	}
	
	function setSecurityService() {
		
		variables.securityService = getBeanFactory(id="factory").getBean("securityService");
		
	}
	
	function setUserService() {
	
		variables.userService = getBeanFactory(id="factory").getBean("userService");
		
	}
	
	function setSessionService() {
	
		variables.sessionService = getBeanFactory(id="factory").getBean("sessionService");
		
	}
	
	function setRssService() {		
	
		variables.rssService = getBeanFactory(id="factory").getBean("rssService");

	}
	
</cfscript>

</cfcomponent>