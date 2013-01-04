$('.edit-project a').each(function(index, link) {
	$(link).pjax("[data-pjax-project-1]");//" + $(link).attr('href').match(/(\d+)/)[0] + "]");
});