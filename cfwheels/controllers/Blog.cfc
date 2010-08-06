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

		label = "Update";
		bookmark = model('bookmark').FindByKey( id );
		
		if (not IsObject(bookmark)) {
			label = "Create";
    		bookmark = model('bookmark').new();
		}

		title = 'LitePost Blog - #label# Link';
		
	}
	
	// category - add/edit category:
	function category() {
		
		var id = 0;
		
		if ( structKeyExists( params, 'key' ) ) {
			id = val( params.key );
		}

		label = "Update";
		category = model('category').FindByKey( id );
		
		if (not IsObject(category)) {
			label = "Create";
    		category = model('category').new();
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
		// TODO: make sure the category doesn't exist in an entry
		
		if (not model('category').deleteByKey(id)) {
			flashInsert(message="This category cannot be deleted. It has an entry filed under it (See below).");
			redirectTo(action="main",params="categoryID=#id#");
		}
		redirectTo(action="main");
	}
	
	// deleteEntry - delete by ID
	function deleteEntry() {
		
		var id = 0;
		
		if ( structKeyExists( params, 'key' ) ) {
			id = val( key );
		}

		aEntry = model("entry").findByKey( id );
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
			label = "Add";
		} else {
			entry = model('entry').FindByKey(id);
			label = "Update";
		}
		
		entry.userId = 1;
		entry.dateLastUpdated = now();
		
		title = 'LitePost Blog - #label# Entry';
		
	}
	
	// logout - end user session:
	function logout() {

		removeUserSession();
		renderPage(action="main");

	}
	
	// main - home page:
	function main() {
		
		if ( structKeyExists( params, 'categoryID' ) and val( params.categoryID ) ) {
			entries = model('entry').findAllByCategoryID(value=categoryID, include='category');
		} else {
			entries = model('entry').findAll(include='category');
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
		var returnValue = '';
		
		if ( structKeyExists( params.bookmark, 'id' ) and val(params.bookmark.id)) {
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
		
		title = 'LitePost Blog - #label# Link';

		if (returnValue) {
    		redirectTo(action="main");
		} else {
    		flashInsert(message="Please complete the bookmark form!");
    		renderPage(action="bookmark");
		}
		
	}

	// saveCategory - create/update category:
	function saveCategory() {
	    var returnValue = '';
		
		if ( structKeyExists( params.category, 'id' ) and val(params.category.id)) {
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
		
		title = 'LitePost Blog - #label# Category';

		if (returnValue) {
    		redirectTo(action="main");
		} else {
    		flashInsert(message="Please complete the category form!");
    		renderPage(action="category");
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
		
		 var returnValue = '';
		
		if ( structKeyExists( params.entry, 'id' ) and val(params.entry.id)) {
  			entry = model("entry").findByKey(params.entry.id); 
			returnValue = entry.update(params.entry);
			label = "Update";
		}
		else 
		{ 
  			entry = model("entry").new(params.entry);
			returnValue = entry.save();
			label = "Update";
		} 
		
		title = 'LitePost Blog - #label# entry';

		if (returnValue) {
    		redirectTo(action="main");
		} else {
    		flashInsert(message="Please complete the entry form!");
    		renderPage(action="entry");
		}
	}
	
</cfscript>
</cfcomponent>