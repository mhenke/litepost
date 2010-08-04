<cfcomponent extends="Controller" output="false">

<cfscript>
	
	// init
	function init() {
		filters("before");
	}
	
	// called before any actions:
	function before() {	
		loadBeanFactory(id="factory",configPath="/config/litepost-services.xml");
		params.test = getBeanFactory(id="factory");
	 	params.isAdmin = isAuthenticated();
	 	params.bookmarks = model('bookmark').FindAll();
	 	// params.categories = getCategoriesWithCounts();
		params.categories = model('category').findAll();
	 }
	 
	 function isAuthenticated() {
	 
	 return false;
	 
	}
	
	
	function removeUserSession() {
	}
	
	
	function getCategoriesWithCounts() {
	}

	// blog actions:
	
	// bookmark - add/edit bookmark:
	function bookmark() {
		
		var id = 0;
		
		if ( structKeyExists( params, 'bookmarkBean') ) {
			return;
		}
		if ( structKeyExists( params, 'bookmarkID' ) ) {
			id = val( params.bookmarkID );
		}
		if ( id == 0 ) {
			bookmark = model('bookmark').new();
		} else {
			bookmark = model('bookmark').findByKey(id);
		}
		
	}
	
	// category - add/edit category:
	function category() {
		
		var id = 0;
		
		if ( structKeyExists( params, 'categoryBean') ) {
			return;
		}
		if ( structKeyExists( params, 'categoryID' ) ) {
			id = val( params.categoryID );
		}
		if ( id == 0 ) {
			category = model('category').new();
		} else {
			category = model('category').FindByKey( id );
		}
		
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
		
		if ( structKeyExists( params, 'bookmarkID' ) ) {
			id = val( params.bookmarkID );
		}
		model('bookmark').deleteByKey(id);
		renderPage(action='main');
	}
	
	// deleteCategory - delete by ID
	function deleteCategory() {
		
		var id = 0;
		
		if ( structKeyExists( params, 'categoryID' ) ) {
			id = val( params.categoryID );
		}
		model('category').deleteByKey(id);
		renderPage(action="main");
	}
	
	// deleteEntry - delete by ID
	function deleteEntry() {
		
		var id = 0;
		
		if ( structKeyExists( params, 'entryID' ) ) {
			id = val( params.entryID );
		}
		// TODO: remove comments for this entry first!
		model('entry').deleteByKey(id);
		renderPage(action="main");
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
		
		if ( structKeyExists( params, 'entryBean') ) {
			return;
		}
		if ( structKeyExists( params, 'entryID' ) ) {
			id = val( params.entryID );
		}
		if ( id == 0 ) {
			entry = model('entry').new();
		} else {
			entry = model('entry').FindByKey(id);
		}
		
	}
	
	// logout - end user session:
	function logout() {

		removeUserSession();
		renderPage(action="main");

	}
	
	// main - home page:
	function main() {
		
		if ( structKeyExists( params, 'categoryID' ) and val( params.categoryID ) gt 0 ) {
			entries = model('entry').findByCategoryID(categoryID);
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
	
	// setters for dependencies:
	function setBookmarkService(bookmarkService) {
		variables.bookmarkService = bookmarkService;
	}
	
	function setCategoryService(categoryService) {
		variables.categoryService = categoryService;
	}
	
	function setCommentService(commentService) {
		variables.commentService = commentService;
	}
	
	function setEntryService(entryService) {
		variables.entryService = entryService;
	}
	
	function setRSSService(rssService) {
		variables.rssService = rssService;
	}
	
	function setSecurityService(securityService) {
		variables.securityService = securityService;
	}
	
	function setUserService(userService) {
		variables.userService = userService;
	}
	
</cfscript></cfcomponent>