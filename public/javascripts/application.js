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

function show_permissions()
{
	if($('permissions').visible()) { show_folder(); return; }
	if($('files_and_folders').visible()) { Effect.BlindUp('files_and_folders', { duration: 0.5 }); }
	if($('clipboard').visible()) { Effect.BlindUp('clipboard', { duration: 0.5 }); }

	Effect.BlindDown('permissions', { delay: 0.5, duration: 0.5 });

	$('show_permissions_link').className = 'highlight';
	$('show_clipboard_link').className = 'folder_menu';
}

function show_folder()
{
	if($('permissions') != undefined && $('permissions').visible()) { Effect.BlindUp('permissions', { duration: 0.5 }); }
	if($('clipboard').visible()) { Effect.BlindUp('clipboard', { duration: 0.5 }); }

	Effect.BlindDown('files_and_folders', { delay: 0.5, duration: 0.5 });

	if($('show_permissions_link') != undefined) { $('show_permissions_link').className = 'folder_menu'; }
	$('show_clipboard_link').className = 'folder_menu';
}

function show_clipboard()
{
	if($('clipboard').visible()) { show_folder(); return; }
	if($('permissions') != undefined && $('permissions').visible()) { Effect.BlindUp('permissions', { duration: 0.5 }); }
	if($('files_and_folders').visible()) { Effect.BlindUp('files_and_folders', { duration: 0.5 }); }

	Effect.BlindDown('clipboard', { delay: 0.5, duration: 0.5 });

	$('show_clipboard_link').className = 'highlight';
	if($('show_permissions_link') != undefined) { $('show_permissions_link').className = 'folder_menu'; }
}