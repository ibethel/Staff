/*!
// Infinite Scroll jQuery plugin
// copyright Paul Irish, licensed GPL & MIT
// version 1.5.110106

// home and docs: http://www.infinite-scroll.com
*/
 
;(function($){
    
  $.fn.infinitescroll = function(options,callback){
    
    // console log wrapper.
    function debug(){
      if (opts.debug) { window.console && console.log.call(console,arguments)}
    }
    
    // grab each selector option and see if any fail.
    function areSelectorsValid(opts){
      for (var key in opts){
        if (key.indexOf && key.indexOf('Selector') > -1 && $(opts[key]).length === 0){
            debug('Your ' + key + ' found no elements.');    
            return false;
        } 
        return true;
      }
    }


    // find the number to increment in the path.
    function determinePath(path){

     if ( path.match(/^(.*?)\b2\b(.*?$)/) ){  
          path = path.match(/^(.*?)\b2\b(.*?$)/).slice(1);
          
      // if there is any 2 in the url at all.    
      } else if (path.match(/^(.*?)2(.*?$)/)){
        
          // page= is used in django:
          //   http://www.infinite-scroll.com/changelog/comment-page-1/#comment-127
          if ( path.match(/^(.*?page=)2(\/.*|$)/) ){
            path = path.match(/^(.*?page=)2(\/.*|$)/).slice(1);
            return path;
          }
          
          debug('Trying backup next selector parse technique. Treacherous waters here, matey.');
          path = path.match(/^(.*?)2(.*?$)/).slice(1);
      } else {
          
        // page= is used in drupal too but second page is page=1 not page=2:
        // thx Jerod Fritz, vladikoff
        if (path.match(/^(.*?page=)1(\/.*|$)/)) {
          path = path.match(/^(.*?page=)1(\/.*|$)/).slice(1);
          return path;
        }  

        if ($.isFunction(opts.pathParse)){
          return [path];
        } else {
          debug('Sorry, we couldn\'t parse your Next (Previous Posts) URL. Verify your the css selector points to the correct A tag. If you still get this error: yell, scream, and kindly ask for help at infinite-scroll.com.');    
          props.isInvalidPage = true;  //prevent it from running on this page.
        }
      }
      return path;
    }
    
    // determine filtering nav for multiple instances
    function filterNav() {
    	opts.isFiltered = true;
    	return $(window).trigger( "error.infscr."+opts.infid, [302] );
    }
	// Calculate internal height (used for local scroll)
	function hiddenHeight(element)
		{
		var height = 0;
		$(element).children().each(function() {
			height = height + $(this).outerHeight(false);
		});
		return height;
		}
	//Generate InstanceID based on random data (to give consistent but different ID's)
	function generateInstanceID(element)
		{
		var number = $(element).length + $(element).html().length + $(element).attr("class").length
			+ $(element).attr("id").length;
		opts.infid	= number;
		}
    function isNearBottom(){
	// distance remaining in the scroll
      // computed as: document height - distance already scroll - viewport height - buffer
      if(opts.container.nodeName=="HTML")
	  	{
		var pixelsFromWindowBottomToBottom = 0 
                + $(document).height()  
                // have to do this bs because safari doesnt report a scrollTop on the html element
                - ($(opts.container).scrollTop() || $(opts.container.ownerDocument.body).scrollTop())
                - $(window).height();	
		}
	  else
	  	{
      	var pixelsFromWindowBottomToBottom = 0 
                + hiddenHeight(opts.container) - $(opts.container).scrollTop() - $(opts.container).height();
		
		}      
      
      debug('math:', pixelsFromWindowBottomToBottom, opts.pixelsFromNavToBottom);
      
      // if distance remaining in the scroll (including buffer) is less than the orignal nav to bottom....
      return (pixelsFromWindowBottomToBottom  - opts.bufferPx < opts.pixelsFromNavToBottom);    
    } 
    
    function showDoneMsg(){
      props.loadingMsg
        .find('img').hide()
        .parent()
          .find('div').html(opts.donetext).animate({opacity: 1},2000, function() {
            $(this).parent().fadeOut('normal');
          });
      
      // user provided callback when done    
      opts.errorCallback();
    }
    
    function infscrSetup(){
        if (opts.isDuringAjax || opts.isInvalidPage || opts.isDone || opts.isFiltered || opts.isPaused) return; 
        
        if ( !isNearBottom(opts,props) )  return ;
        $(document).trigger('retrieve.infscr.'+opts.infid);
                
    }  // end of infscrSetup()
          
  
      
    function kickOffAjax(){
        
        // we dont want to fire the ajax multiple times
        opts.isDuringAjax = true; 
        
        // show the loading message quickly
        // then hide the previous/next links after we're
        // sure the loading message was visible
        props.loadingMsg.appendTo( opts.loadMsgSelector ).show(opts.loadingMsgRevealSpeed, function(){
	        $( opts.navSelector ).hide(); 
	        
	        // increment the URL bit. e.g. /page/3/
	        opts.currPage++;
	        
	        debug('heading into ajax',path);
	        
	        // if we're dealing with a table we can't use DIVs
	        box = $(opts.contentSelector).is('table') ? $('<tbody/>') : $('<div/>');
	        frag = document.createDocumentFragment();
	        
	        
	        if ($.isFunction(opts.pathParse)){
		        // if we got a custom path parsing function, pass in our path guess and page iteration
		        desturl = opts.pathParse(path.join('2'), opts.currPage);
		    } else {
		      	desturl = path.join( opts.currPage );
		    }
		    box.load( desturl + ' ' + opts.itemSelector,null,loadCallback);
		    
	    });
        
    }
    
    function loadCallback(){
        // if we've hit the last page..
		
        if (opts.isDone){ 
            showDoneMsg();
            return false;    
              
        } else {
          
            var children = box.children();
            
            // if it didn't return anything
            if (children.length == 0 || children.hasClass('error404')){
              // trigger a 404 error so we can quit.
              return infscrError([404]); 
            } 
            
            // use a documentFragment because it works when content is going into a table or UL
            while (box[0].firstChild){
              frag.appendChild(  box[0].firstChild );
            }
           	$(opts.contentSelector)[0].appendChild(frag);
            
            // fadeout currently makes the <em>'d text ugly in IE6
            props.loadingMsg.fadeOut('normal' ); 

            // smooth scroll to ease in the new content
            if (opts.animate){ 
                var scrollTo = $(window).scrollTop() + $('#infscr-loading').height() + opts.extraScrollPx + 'px';
                $('html,body').animate({scrollTop: scrollTo}, 800,function(){ opts.isDuringAjax = false; }); 
            }
        
            // previously, we would pass in the new DOM element as context for the callback
            // however we're now using a documentfragment, which doesnt havent parents or children,
            // so the context is the contentContainer guy, and we pass in an array
            //   of the elements collected as the first argument.
            callback.call( $(opts.contentSelector)[0], children.get() );
        
            if (!opts.animate) opts.isDuringAjax = false; // once the call is done, we can allow it again.
        }
    }
    
    function initPause(pauseValue) {
    	if (pauseValue == "pause") {
    		opts.isPaused = true;
    	} else if (pauseValue == "resume") {
    		opts.isPaused = false;
    	} else {
    		opts.isPaused = !opts.isPaused;
    	}
    	debug('Paused: ' + opts.isPaused);
    	return false;
    }
    function infscrError(xhr){
    	if (!opts.isDone && xhr == 404) {
		    // die if we're out of pages.
	    	debug('Page not found. Self-destructing...');
	    	showDoneMsg();
	    	opts.isDone = true;
	    	opts.currPage = 1; // if you need to go back to this instance
	    	$(window).unbind('scroll.infscr.'+opts.infid);
	    	$(document).unbind('retrieve.infscr.'+opts.infid);
    	}
    	if (opts.isFiltered && xhr == 302) {
    		// die if filtered.
	    	debug('Filtered. Going to next instance...');
	    	opts.isDone = true;
	    	opts.currPage = 1; // if you need to go back to this instance
	    	opts.isPaused = false;
	    	$(window).unbind('scroll.infscr.'+opts.infid, infscrSetup)
	    	  .unbind('pause.infscr.'+opts.infid)
	    	  .unbind('filter.infscr.'+opts.infid)
	    	  .unbind('error.infscr.'+opts.infid);
	    	$(document).unbind('retrieve.infscr.'+opts.infid,kickOffAjax);
	    }
    }
    
      
    // lets get started.
    $.browser.ie6 = $.browser.msie && $.browser.version < 7;
    
    var opts    = $.extend({}, $.infinitescroll.defaults, options),
        props   = $.infinitescroll, // shorthand
        box, frag, desturl, thisPause, errorStatus;
    callback    = callback || function(){};
	
    if (!areSelectorsValid(opts)){ return false;  }
    
    opts.container   =  opts.container || document.documentElement;
                          
    // contentSelector we'll use for our .load()
    opts.contentSelector = opts.contentSelector || this;
	// Generate unique instance ID
	if(opts.infid==0)
	generateInstanceID(opts.contentSelector);
    // loadMsgSelector - if we want to place the load message in a specific selector, defaulted to the contentSelector
    opts.loadMsgSelector = opts.loadMsgSelector || opts.contentSelector;
    
    // get the relative URL - everything past the domain name.
    var relurl        = /(.*?\/\/).*?(\/.*)/,
        path          = $(opts.nextSelector).attr('href');
    
    
    if (!path) { debug('Navigation selector not found'); return; }
    
    // set the path to be a relative URL from root.
    path          = determinePath(path);
	    
    // define loading msg
    props.loadingMsg = $('<div id="infscr-loading" style="text-align: center;"><img alt="Loading..." src="'+
                                  opts.loadingImg+'" /><div>'+opts.loadingText+'</div></div>');    
     // preload the image
    (new Image()).src    = opts.loadingImg;
    //Check if its HTML (window scroll)
	if(opts.container.nodeName=="HTML")
		{
		debug("Window Scroll");
		var innerContainerHeight 	= $(document).height();
		var binder					= $(window);
		}
	else
		{
		debug("Local Scroll");
		var innerContainerHeight 	= hiddenHeight(opts.container);	
		var binder					= $(opts.container);
		}
	// distance from nav links to bottom
    // computed as: height of the document + top offset of container - top offset of nav link
    opts.pixelsFromNavToBottom =  innerContainerHeight  +
                                     (opts.container == document.documentElement ? 0 : $(opts.container).offset().top )- 
                                     $(opts.navSelector).offset().top;
	
	// set up our bindings
    // bind scroll handler to element (if its a local scroll) or window 
    binder
      .bind('scroll.infscr.'+opts.infid, infscrSetup)
      .bind('filter.infscr.'+opts.infid, filterNav)
      .bind('error.infscr.'+opts.infid, function(event,errorStatus) { infscrError(errorStatus); })
      .bind('pause.infscr.'+opts.infid, function(event,thisPause) { initPause(thisPause); })
      .trigger('scroll.infscr.'+opts.infid); // trigger the event, in case it's a short page
          
    $(document).bind('retrieve.infscr.'+opts.infid,kickOffAjax);
    
    return this;
  
  }  // end of $.fn.infinitescroll()
  

  
  // options and read-only properties object
  
  $.infinitescroll = {     
        defaults      : {
                          debug           : false,
                          preload         : false,
                          nextSelector    : "div.navigation a:first",
                          loadingImg      : "http://www.infinite-scroll.com/loading.gif",
                          loadingText     : "<em>Loading the next set of posts...</em>",
                          donetext        : "<em>Congratulations, you've reached the end of the internet.</em>",
                          navSelector     : "div.navigation",
                          contentSelector : null,           // not really a selector. :) it's whatever the method was called on..
                          loadMsgSelector : null,
                          loadingMsgRevealSpeed : 'fast', // controls how fast you want the loading message to come in, ex: 'fast', 'slow', 200 (milliseconds)
                          extraScrollPx   : 150,
                          itemSelector    : "div.post",
                          animate         : false,
                          pathParse       : undefined,
                          bufferPx        : 40,
                          errorCallback   : function(){},
                          currPage        : 1,
						  infid		  	  : 0, //Instance ID (Generated at setup)
                          isDuringAjax    : false,
                          isInvalidPage   : false,
                          isFiltered	  : false,
                          isDone          : false,  // for when it goes all the way through the archive.
                          isPaused        : false,
						  container       : undefined, //If left undefined uses window scroll, set as container for local scroll
						  pixelsFromNavToBottom	: undefined
                        }, 
        loadingImg    : undefined,
        loadingMsg    : undefined,
        currDOMChunk  : null  // defined in setup()'s load()
  };
  


})(jQuery);