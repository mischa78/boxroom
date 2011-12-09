//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .

$(window).load(function() {
	fadeout('#notice');
	fadeout('#alert');
});

function fadeout(element)
{
	if($(element) != undefined)
	{
		$(element).delay(1500).fadeOut('slow');
	}
}

function show_element(element)
{
	if($(element).is(':visible')) { element = '#files_and_folders'; }

	elements = ['#files_and_folders', '#permissions', '#clipboard'];
	elements.splice(elements.indexOf(element), 1);

	jQuery.each(elements, function(index, value) {
		if($(value) != undefined && $(value).is(':visible')) { $(value).slideUp('slow'); }
	});

	$(element).slideDown('slow');
	if($(element + '_link') != undefined) { $(element + '_link').removeClass('folder_menu').addClass('highlight'); }

	jQuery.each(elements, function(index, value) {
		if($(value + '_link') != undefined) { $(value + '_link').removeClass('highlight').addClass('folder_menu'); }
	});
}

function update_counter(element)
{
	$('#counter').html(element.value.length);
	$('#counter').css('color', element.value.length > 256 ? '#F00' : '#000');
}
