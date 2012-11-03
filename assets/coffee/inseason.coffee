$ ->
  $('.state-selector').change ->
    window.location = '/' + $('.state-selector').val().toLowerCase()
