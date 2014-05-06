//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require_self
//= require_tree .

$(window).load ->
  fadeout '#notice'
  fadeout '#alert'

jQuery ->
  $('.back_link').on 'click', (e) ->
    e.preventDefault()
    show_element '#files_and_folders'

  $('.permissions_link').on 'click', (e) ->
    e.preventDefault()
    show_element '#permissions'

  $('.clipboard_link').on 'click', (e) ->
    e.preventDefault()
    show_element '#clipboard'

  $('.emails_to_share_with').on 'change', (e) ->
    update_counter e.target

  $('.emails_to_share_with').on 'keyup', (e) ->
    update_counter e.target

fadeout = (el) ->
  $(el).delay(3000).fadeOut('slow')

show_element = (el) ->
  el = '#files_and_folders' if $(el).is(':visible')

  elements = ['#files_and_folders', '#permissions', '#clipboard']
  elements.splice elements.indexOf(el), 1
  hide_elements elements

  $(el).slideDown('slow')
  $("#{el}_link").removeClass('folder_menu').addClass('highlight')

hide_elements = (elements) ->
  for element in elements
    $(element).slideUp('slow') if $(element).is(':visible')
    $("#{element}_link").removeClass('highlight').addClass('folder_menu')

update_counter = (el) ->
  $('#counter').html el.value.length
  $('#counter').css 'color', if el.value.length > 255 then '#F00' else '#000'
