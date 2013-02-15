function makeTechnologyIconIntoCheckbox(_, container) {
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
}

function addProjectCallback(_, response) {
	var $new_row = $($("<div class='row-fluid project'>").insertBefore($('.add-project').parent()));
	$new_row.html(response);
	$new_row.find('.checkbox-container').each(makeTechnologyIconIntoCheckbox);
	$new_row.find('form').bind("ajax:success", saveProjectCallback);
	$new_row.find('.cancel').click(function() { $new_row.remove(); });
}

function editProjectCallback(_, response) {
	var $project_row = $($(this).closest('.project'));
	$project_row.html(response);
	$project_row.find('.checkbox-container').each(makeTechnologyIconIntoCheckbox);
	$project_row.find('form').bind("ajax:success", saveProjectCallback);
}

function deleteProjectCallback() {
	$(this).closest('.project').remove();
}

function saveProjectCallback(_, response) {
	var $project_row = $($(this).closest('.project'));
	$project_row.html(response);
	$project_row.find('.edit-project').bind("ajax:success", editProjectCallback);
    $project_row.find('.delete-project').bind("ajax:success", deleteProjectCallback);		
}

$('.edit-project').each(function(_, editElement) {
	$(editElement).bind("ajax:success", editProjectCallback);
});

$('.delete-project').each(function(_, deleteElement) {
	$(deleteElement).bind("ajax:success", deleteProjectCallback);
});

$('.add-project').bind("ajax:success", addProjectCallback);