// Generated by CoffeeScript 1.12.6
(function() {
  $(function() {
    $('.state-selector').change(function() {
      return window.location = '/' + $('.state-selector').val().toLowerCase();
    });
    return $('.search').keyup(function() {
      return $('tr').each(function() {
        if ($(this).data('crop').match($('.search').val().toLowerCase())) {
          return $(this).show();
        } else {
          return $(this).hide();
        }
      });
    });
  });

}).call(this);
