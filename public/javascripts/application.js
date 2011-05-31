Event.observe(window, 'load', function() {
	fadeout.delay(1.5, 'notice');
	fadeout.delay(1.5, 'alert');
});

function fadeout(element)
{
	if($(element) != undefined)
	{
		Effect.Fade(element, { duration: 1.5 });
	}
}

function show_element(element)
{
	elements = ['files_and_folders', 'permissions', 'clipboard'];
	elements.splice(elements.indexOf(element), 1);

	elements.each(function(e) {
		if($(e) != undefined && $(e).visible()) { Effect.BlindUp(e, { duration: 0.5 }); }
	})

	Effect.BlindDown(element, { delay: 0.5, duration: 0.5 });
	if($('show_' + element + '_link') != undefined) { $('show_' + element + '_link').className = 'highlight'; }

	elements.each(function(e) {
		if($('show_' + e + '_link') != undefined) { $('show_' + e + '_link').className = 'folder_menu'; }
	})
}
