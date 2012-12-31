$('.checkbox-container').each(function(index, container) {
	var $container = $(container);
	var $checkbox = $container.find('input[type="checkbox"]');
	var $hiddenbox = $container.find('input[type="hidden"]');
	if ($checkbox.prop('checked')) {
		$container.find('.unused-technology').addClass('hidden');
	} else {
		$container.find('.used-technology').addClass('hidden');
	}
	$container.click(function() {
		$container.find('.unused-technology').toggleClass('hidden');
		$container.find('.used-technology').toggleClass('hidden');
		$checkbox.prop('checked', !$checkbox.prop('checked'));
	});
});