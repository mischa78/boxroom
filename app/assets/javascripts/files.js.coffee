jQuery ->
  $('#new_user_file').fileupload
    dataType: 'script'
    add: (e, data) ->
      $('#user_file_attachment').prop('disabled', true)
      file = data.files[0]
      folder = $('#target_folder_id').val()
      $.getJSON "/file_exists?name=#{encodeURIComponent(file.name)}&folder=#{encodeURIComponent(folder)}", (exists) ->
        data.context = $(tmpl("template-upload", file).trim())
        $('#progress').append(data.context)
        if exists
          data.context.find('.progress').hide()
          data.context.find('.failed').show()
          data.context.find('.exists_message').show()
          $('#user_file_attachment').prop('disabled', false)
        else
          data.submit()          
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100)
        data.context.find('.progress-bar').css('width', "#{progress}%").attr('aria-valuenow', progress).html("#{progress}%"); 
        if data.loaded == data.total
          data.context.find('.progress-bar').removeClass("active").removeClass("progress-bar-striped").addClass("progress-bar-success")
          data.context.find('.tick').show()
    stop: (e) ->
      folder = $('#target_folder_id').val()
      window.location.href = "/folders/#{folder}"
