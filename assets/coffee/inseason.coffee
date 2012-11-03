$ ->
  $('.state-selector').change ->
    window.location = '/' + $('.state-selector').val().toLowerCase()

  $('.search').keyup ->
    $('tr').each ->
      if $(this).data('crop').match($('.search').val().toLowerCase())
        $(this).show()
      else
        $(this).hide()
