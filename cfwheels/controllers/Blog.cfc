<cfcomponent extends="Controller" output="false">

<cfscript>
	
	// init
	function init() {
		filters("before");
	}
	
	// called before any actions:
	function before() {	
		loadBeanFactory(id="factory",configPath="/config/litepost-services.xml");
	 	params.isAdmin = isAuthenticated();
	 	params.bookmarks = model('bookmark').FindAll();
		params.categories = model('category').findAll();
	 }
	 
	 function isAuthenticated() {
	 
	 return true;
	 
	}
	
	
	function removeUserSession() {
	}
	
	
	// blog actions:
	
	// bookmark - add/edit bookmark:
	function bookmark() {
		
		var id = 0;
		
		if ( structKeyExists( params, 'key' ) ) {
			id = val( params.key );
		}

		bookmark = model('bookmark').FindByKey( key=id, returnAs="query" );

		if ( bookmark.id GT 0 ) {
			label = "Update";
		} else {
			label = "Create";
		}
		
		title = 'LitePost Blog - #label# Link';
		
	}
	
	// category - add/edit category:
	function category() {
		
		var id = 0;
		
		if ( structKeyExists( params, 'key' ) ) {
			id = val( params.key );
		}
		
		category = model('category').FindByKey( key=id, returnAs="query" );

		if ( category.id GT 0 ) {
			label = "Update";
		} else {
			label = "Create";
		}
		
		title = 'LitePost Blog - #label# Category';
		
	}
	
	// comments - show entry with comments:
	function comments() {
		
		var id = 0;
		
		if ( structKeyExists( params, 'entryID' ) ) {
			id = val( params.entryID );
		}
		params.entry = model('entry').FindByKey(id);
		if ( structKeyExists( params, 'comment') ) {
			return;
		}
		comment = model('comment').new();
		
	}
	
	// deleteBookmark - delete by ID
	function deleteBookmark() {
		var id = 0;
		
		if ( structKeyExists( params, 'key' ) ) {
			id = val( params.key);
		}
		model('bookmark').deleteByKey(id);
		redirectTo(action="main");
	}
	
	// deleteCategory - delete by ID
	function deleteCategory() {
		var id = 0;
		
		if ( structKeyExists( params, 'key' ) ) {
			id = val( params.key);
		}
		model('category').deleteByKey(id);
		redirectTo(action="main");
	}
	
	// deleteEntry - delete by ID
	function deleteEntry() {
		
		var id = 0;
		
		if ( structKeyExists( params, 'key' ) ) {
			id = val( key );
		}

		aEntry = model("entry").findByKey( id );
		aEntry.deleteAllComments();
		aEntry.delete();

		flashInsert(message="#aEntry.title# entry and comments deleted!");

		entries = model('entry').findAll();
		redirectTo(action="main");
	}
	
	// doLogin - attempt authentication:
	function doLogin() {
		
		user = model('user').findOne(where="username='#params.username#' AND password='#params.password#'");
		
		// userService.authenticate
		if ( NOT isObject(user)) {
		
			flashInsert(message="User not found!");
			redirectTo(action="login");
		} else {
			//  store validated user in session
			redirectTo(action="main");
		}
		
	}
	
	// entry - add/edit entry:
	function entry() {
		var id = 0;
		
		if ( structKeyExists( params, 'entryID' ) ) {
			id = val( params.entryID );
		}
		if ( id == 0 ) {
			entry = model('entry').new();
			entry.id = id;
			entry.title = '';
			entry.body = '';
		} else {
			entry = model('entry').FindByKey(id);
		}
		
		if ( entry.id GT 0 ) {
			label = "Update";
		} else {
			label = "Add";
		}
		
		entry.CategoryID = '';
	
		title = 'LitePost Blog - #label# Entry';
		
	}
	
	// logout - end user session:
	function logout() {

		removeUserSession();
		renderPage(action="main");

	}
	
	// main - home page:
	function main() {
		
		if ( structKeyExists( params, 'categoryID' ) and val( params.categoryID ) gt 0 ) {
			entries = model('entry').findByKey(key=categoryID, returnAs='query');
		} else {
			entries = model('entry').findAll();
		}

	}
	
	function rss() {
		
		var args = structCopy( variables.fw.getBlogConfiguration() );
			
		// additional arguments used in RSSService:
		args.eventParameter = variables.fw.getAction();
		args.eventLocation = 'blog.comments';
		args.generator = 'LitePost';
		
		// fixup blogLanguage:
		args.blogLanguage = replace(lcase(args.blogLanguage), "_", "-", "one");
		
		if ( structKeyExists( params, 'categoryID' ) ) {
			args.categoryId = params.categoryId;
			args.categoryName = params.categoryName;
			params.rss = variables.rssService.getCategoryRSS( argumentCollection=args );
		} else {
			params.rss = variables.rssService.getBlogRSS( argumentCollection=args );
		}
		
	}

	// saveBookmark - create/update bookmark:
	function saveBookmark() {
		
		bookmark = model("bookmark").findByKey(params.id);

		if (bookmark.save()) {
			flashInsert(message="Success!");
    		redirectTo(action="main");
		} else {
    		flashInsert(message="Please complete the bookmark form!");
    		redirectTo(action="bookmark");
		}
		
	}

	// saveCategory - create/update category:
	function saveCategory() {
	
		category = model("category").new(params);
		
		if (category.save()) {
    		redirectTo(action="main");
		} else {
    		flashInsert(message="Please complete the category form!");
    		redirectTo(action="category");
		}
		
	}

	// saveComment - create/update comment:
	function saveComment() {
		
		var bean = variables.commentService.getNewComment();
		
		variables.fw.populate( bean );
		
		if ( bean.validate() ) {

			variables.commentService.saveComment( bean );
			variables.fw.redirect( 'blog.comments', '', 'entryId' );
			
		} else {

			rc.message = 'Please complete the comment form!';
			rc.commentBean = bean;
			variables.fw.redirect( 'blog.comments', 'message,commentBean', 'entryId' );
			
		}
	}

	// saveEntry - create/update entry:
	function saveEntry() {

		params.userID = 1;
		params.dateLastUpdated = now();
		entry = model("Entry").save(params);

		if ( not entry.hasErrors() ) {

			redirectTo( action="main" );
			
		} else {

			flashInsert(message="Please complete the entry form!");
			renderPage( action="entry" );
			
		}
	}
	
</cfscript>
</cfcomponent>