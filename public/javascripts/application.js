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
	if($('files_and_folders').visible()) { Effect.BlindUp('files_and_folders'); }
	if($('clipboard').visible()) { Effect.BlindUp('clipboard'); }

	Effect.BlindDown('permissions', { delay: 1.0 });

	$('show_permissions_link').className = 'highlight';
	$('show_clipboard_link').className = 'folder_menu';
}

function show_folder()
{
	if($('permissions') != undefined && $('permissions').visible()) { Effect.BlindUp('permissions'); }
	if($('clipboard').visible()) { Effect.BlindUp('clipboard'); }

	Effect.BlindDown('files_and_folders', { delay: 1.0 });

	if($('show_permissions_link') != undefined) { $('show_permissions_link').className = 'folder_menu'; }
	$('show_clipboard_link').className = 'folder_menu';
}

function show_clipboard()
{
	if($('clipboard').visible()) { show_folder(); return; }
	if($('permissions') != undefined && $('permissions').visible()) { Effect.BlindUp('permissions'); }
	if($('files_and_folders').visible()) { Effect.BlindUp('files_and_folders'); }

	Effect.BlindDown('clipboard', { delay: 1.0 });

	$('show_clipboard_link').className = 'highlight';
	if($('show_permissions_link') != undefined) { $('show_permissions_link').className = 'folder_menu'; }
}