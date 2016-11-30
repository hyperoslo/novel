$(function () {
	// Toggle sidebar
	$('#sidebar-collapse-btn').on('click', function(event){
		event.preventDefault();

		$("#app").toggleClass("open");
		$("#sidebar").toggleClass("open");
	});

	// Set active navigation item
  $('#sidebar-menu > li > a[href="' + document.location.pathname + '"]').parent().addClass('active');
});
