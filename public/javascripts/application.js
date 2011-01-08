$(function(){
	
	if($('#all-staff-list').html())
	{
		$('#all-staff-list').infinitescroll({
		    navSelector  : "div.pagination",   // selector for the paged navigation (it will be hidden)
		    nextSelector : "div.pagination a:first", // selector for the NEXT link (to page 2)
		    itemSelector : "div.single-user", // selector for all items you'll retrieve
			loadingText : "",
			animate		: false,
			donetext     : "Nice work!  You have met everyone!",
			loadingImg	: "/images/loading.gif"
		});
	}
	
});