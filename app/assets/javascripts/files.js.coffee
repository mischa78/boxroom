jQuery ->
	$('#new_user_file').fileupload
		dataType: 'script'
		add: (e, data) ->
			$('#user_file_attachment').prop('disabled', true)
			folder = $('#target_folder_id').val()
			file = data.files[0].name
			$.get "/file_exists?name=#{file}&folder=#{folder}", () ->
				if !exists
					$('#status').html("Uploading <strong>#{data.files[0].name}</strong>...");
					$('#progress').show();
					data.submit()
		progress: (e, data) ->
			progress = parseInt(data.loaded / data.total * 100)
			$('#percentage').html("#{progress}%")
